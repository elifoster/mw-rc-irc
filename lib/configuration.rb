require 'yaml'

module Configuration
  PWD = Dir.pwd
  CONFIG = YAML.load_file("#{PWD}/config.yml")

  IRC_USERNAME = CONFIG['irc']['user']
  IRC_PASSWORD = CONFIG['irc']['pass']
  IRC_REALNAME = CONFIG['irc']['real']
  IRC_NICKNAMES = CONFIG['irc']['nicks']
  IRC_SERVER = CONFIG['irc']['server']
  IRC_PORT = CONFIG['irc']['port']
  IRC_CHANNELS = CONFIG['irc']['channels']
  IRC_DEV_CHANNELS = CONFIG['irc']['dev_channels']

  WIKI_URL = CONFIG['wiki']['url']
  WIKI_USERNAME = CONFIG['wiki']['user']
  WIKI_PASSWORD = CONFIG['wiki']['pass']
  WATCHLIST = CONFIG['wiki']['watchlist']
end
