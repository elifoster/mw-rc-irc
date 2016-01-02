require 'cinch'
require 'mediawiki/butt'
require_relative 'configuration'
require_relative 'plugins/recent_changes'

module RecentChangesBot
  extend self

  WIKI = MediaWiki::Butt.new(Configuration::WIKI_URL)

  IRC = Cinch::Bot.new do
    configure do |c|
      c.server = Configuration::IRC_SERVER
      c.port = Configuration::IRC_PORT
      c.channels = ARGV[0] == '-d' ? Configuration::IRC_DEV_CHANNELS : Configuration::IRC_CHANNELS
      c.nicks = Configuration::IRC_NICKNAMES
      c.user = Configuration::IRC_USERNAME
      c.password = Configuration::IRC_PASSWORD
      c.realname = Configuration::IRC_REALNAME
      c.plugins.plugins = [
        Plugins::RecentChanges
      ]
    end
  end

  def init_wiki
    if WIKI.user_bot?
      WIKI.login(Configuration::WIKI_USERNAME, Configuration::WIKI_PASSWORD)
    end

    WIKI
  end

  def run
    IRC.start
  end
end
