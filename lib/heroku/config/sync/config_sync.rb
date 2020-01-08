require 'platform-api'

module Heroku
  module Config
    module Sync
      class ConfigSync
        def self.sync
          new(Sync.configuration).sync
        end

        def initialize(config)
          raise "token must be set" unless config.token

          @config = config
          @heroku = PlatformAPI.connect_oauth(@config.token)
        end

        def sync
          src_vars = vars_for(@config.src_app)
          dst_vars = vars_for(@config.dst_app)

          _sync(src_vars, dst_vars)
        end

        private

        def _sync(src_vars, dst_vars)
          update = src_vars.reduce({}) do |m, (var, val)|
            m[var] = src_vars[var] unless src_vars[var] == dst_vars[var]
            m
          end

          if update.empty?
            puts "#{@config.vars.join(", ")} for #{@config.dst_app} all match #{@config.src_app}, doing nothing."
          else
            puts "Updating #{update.keys.join(", ")} on #{@config.dst_app}"
            @heroku.config_var.update(@config.dst_app, update)
          end
        end

        def vars_for(app)
          configs = @heroku.config_var.info_for_app(app)

          configs.select do |var, val|
            @config.vars.include?(var)
          end
        end
      end
    end
  end
end
