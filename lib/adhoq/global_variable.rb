require 'monitor'

module Adhoq
  module GlobalVariable
    def self.extended(base)
      base.extend MonitorMixin
    end

    def current_storage
      synchronize do
        @current_storage ||= setup_storage(*Adhoq.config.storage)
      end
    end

    def configure
      yield config
    end

    def config
      @config ||= Adhoq::Configuration.new
    end

    private

    def setup_storage(type, *args) # rubocop:disable Metrics/MethodLength
      klass =
        case type
        when :local_file then Adhoq::Storage::LocalFile
        when :s3         then Adhoq::Storage::S3
        when :google     then Adhoq::Storage::Google
        when :on_the_fly then Adhoq::Storage::OnTheFly
        when :cache      then Adhoq::Storage::Cache
        else
          raise NotImplementedError
        end

      klass.new(*args)
    end
  end
end
