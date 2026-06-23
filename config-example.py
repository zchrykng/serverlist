# Enables detailed tracebacks and an interactive Python console on errors.
# Never use in production!
DEBUG = False

# Address for development server to listen on
HOST = "127.0.0.1"
# Port for development server to listen on
PORT = 5000

# Directory for persistent server state and generated public list JSON.
# Set SERVERLIST_DATA_DIR in the environment to override this.
DATA_DIR = None

# Optional path to a DB-IP MMDB database.
# Set SERVERLIST_GEOIP_DATABASE in the environment to override this.
GEOIP_DATABASE = None

# Amount of time, is seconds, after which servers are removed from the list
# if they haven't updated their listings.  Note: By default Luanti servers
# only announce once every 5 minutes, so this must be more than 300.
PURGE_TIME = 330

# List of banned IP addresses for announce
# e.g. ['2620:101::44']
BANNED_IPS = []

# List of banned servers as host/port pairs
# e.g. ['1.2.3.4/30000', 'lowercase.hostname', 'lowercase.hostname/30001']
BANNED_SERVERS = []

# Creates server entries if a server sends an 'update' and there is no entry yet.
# This should only be used to populate the server list after store.json was deleted.
# This WILL cause data such as mods, privs or mapgen to be missing from such servers.
ALLOW_UPDATE_WITHOUT_OLD = False

# Reject servers with private addresses and domain names.
# Enable this if you are running a list on the public internet.
# Set SERVERLIST_REJECT_PRIVATE_ADDRESSES in the environment to override this.
REJECT_PRIVATE_ADDRESSES = False
