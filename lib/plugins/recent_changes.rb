require 'cinch'
require 'pp'

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
      p @last_time
      if @last_time.nil?
        @last_time = Time.now.utc
        return
      end
      time = Time.now.utc
      p time
      wiki = RecentChangesBot.init_wiki
      rc = wiki.get_recent_changes(nil, time, @last_time, 5000)
      @last_time = time
      return if rc.size == 0

      rc.each do |log|
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
