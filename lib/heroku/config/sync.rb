require "heroku/config/sync/version"
require "heroku/config/sync/configuration"
require "heroku/config/sync/config_sync"

module Heroku
  module Config
    module Sync
      class Error < StandardError; end

      class << self
        attr_writer :configuration
      end

      def self.configuration
        @configuration ||= Config.new
      end

      def self.configure
        yield(configuration)
      end

      def self.run
        ConfigSync.sync
      end
    end
  end
end
