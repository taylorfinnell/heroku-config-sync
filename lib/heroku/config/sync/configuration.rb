module Heroku
  module Config
    module Sync
      class Config
        attr_accessor :src_app, :dst_app, :vars, :token

        def initialize
          @src_app = nil
          @dst_app = nil
          @vars = []
          @token = nil
        end
      end
    end
  end
end
