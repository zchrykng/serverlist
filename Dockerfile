FROM alpine:3.23

EXPOSE 5000
WORKDIR /usr/src/app
VOLUME ["/data"]

RUN apk add --no-cache \
	python3 \
	py3-flask \
	py3-maxminddb \
	uwsgi-python3 \
	uwsgi-http \
	nodejs \
	npm

COPY . .

RUN npm install dot "commander@11.1.0" mkdirp

RUN cd static && ../node_modules/dot/bin/dot-packer -s .

ARG DBIP_RELEASE
RUN DBIP_RELEASE="${DBIP_RELEASE}" python3 - <<'PY'
import datetime
import gzip
import os
import sys
import urllib.error
import urllib.request

def previous_month(value):
	year, month = map(int, value.split("-"))
	if month == 1:
		return f"{year - 1}-12"
	return f"{year}-{month - 1:02d}"

release = os.environ.get("DBIP_RELEASE") or datetime.datetime.now(datetime.UTC).strftime("%Y-%m")
releases = [release, previous_month(release)]

for item in releases:
	url = f"https://download.db-ip.com/free/dbip-country-lite-{item}.mmdb.gz"
	try:
		request = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
		with urllib.request.urlopen(request) as response:
			data = response.read()
	except urllib.error.HTTPError as exc:
		print(f"{url}: {exc}", file=sys.stderr)
		continue

	with gzip.open(__import__("io").BytesIO(data), "rb") as source:
		with open(f"dbip-country-lite-{item}.mmdb", "wb") as target:
			target.write(source.read())
	break
else:
	raise SystemExit("Unable to download current or previous DB-IP country lite database")
PY

ENV SERVERLIST_DATA_DIR=/data
ENV SERVERLIST_REJECT_PRIVATE_ADDRESSES=1

RUN addgroup -S serverlist \
	&& adduser -S -G serverlist serverlist \
	&& mkdir -p /data \
	&& chown -R serverlist:serverlist /data /usr/src/app

USER serverlist

CMD ["uwsgi", "--plugins", "http,python3", \
	"--http", ":5000", "--master", \
	 "-w", "server:app", \
	"-T", "--threads", "2"]
