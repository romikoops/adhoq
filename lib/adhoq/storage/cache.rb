module Adhoq
  module Storage
    class Cache
      attr_reader :identifier, :cache, :cache_prefix, :expire

      def initialize(cache, cache_prefix = '', expire = 300)
        @cache = cache
        @identifier = @cache_prefix = cache_prefix
        @expire = expire
      end

      def store(prefix: nil, suffix: nil, seed: Time.now)
        Adhoq::Storage.with_new_identifier(prefix: prefix, suffix: suffix, seed: seed) do |id|
          cache.write(cache_prefix + id, yield.read, expires_in: expire)
        end
      end

      def direct_download?
        false
      end

      def get(id)
        cache.read(cache_prefix + id)
      end

      def get_url(_report)
        raise NotImplementedError
      end
    end
  end
end
