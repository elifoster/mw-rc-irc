require 'cinch'
require_relative '../configuration'

module Plugins
  class RecentChanges
    include Cinch::Plugin

    NO_COMMENT = 'No comment :('.freeze
    NEW = ' New!'.freeze
    MINOR = ' Minor!'.freeze
    BOT = ' Bot!'.freeze
    PATROLLED = '!! '.freeze

    @last_time = nil

    timer(15, method: :execute)

    def execute
      if @last_time.nil?
        @last_time = Time.now.utc
        return
      end
      time = Time.now.utc
      wiki = RecentChangesBot.init_wiki
      rc = wiki.get_recent_changes(nil, time, @last_time, 5000)
      watchlist = wiki.get_full_watchlist(nil, 5000) if Configuration::WATCHLIST
      @last_time = time
      return if rc.size == 0

      rc.each do |log|
        next if Configuration::WATCHLIST && !watchlist.include?(log[:title])
        next if Configuration::WATCHLIST && log[:user] == Configuration::WIKI_USERNAME
        message = "[#{log[:type].capitalize} #{log[:revid]}] #{log[:title]} (#{log[:user]}) "
        if log[:comment].empty?
          message << NO_COMMENT
        else
          message << log[:comment]
        end
        message << " (#{log[:diff_length]})"
        message << NEW if log[:new]
        message << MINOR if log[:minor]
        message << BOT if log[:bot]
        message.prepend(PATROLLED) if log[:patrolled]
        RecentChangesBot::IRC.channels.each do |channel|
          channel.send(message)
        end
      end
    end
  end
end
