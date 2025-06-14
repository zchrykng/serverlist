FROM alpine:latest

EXPOSE 5000
WORKDIR /usr/src/app

RUN apk add --no-cache \
	python3 \
	unzip \
	wget \
	py3-pip \
	py3-flask \
	py3-maxminddb \
	uwsgi-python3 \
	uwsgi-http \
	nodejs

COPY . .

RUN cd static && ../node_modules/dot/bin/dot-packer -s .

RUN wget https://download.db-ip.com/free/dbip-country-lite-2025-06.mmdb.gz

RUN gunzip dbip-country-lite-2025-06.mmdb.gz

COPY config-example.py config.py

RUN sed -i 's/REJECT_PRIVATE_ADDRESSES = False/REJECT_PRIVATE_ADDRESSES = True/' config.py

CMD ["uwsgi", "--plugins", "http,python3", \
	"--http", ":5000", "--master", \
	 "-w", "server:app", \
	"-T", "--threads", "2"]
