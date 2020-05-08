module Adhoq
  module Storage
    class FogStorage
      def store(prefix: nil, suffix: nil, seed: Time.now)
        Adhoq::Storage.with_new_identifier(prefix: prefix, suffix: suffix, seed: seed) do |identifier|
          io = yield
          io.rewind

          directory.files.create(key: identifier, body: io, public: false)
        end
      end

      def direct_download?
        false
      end

      def get(identifier)
        get_raw(identifier).body
      end

      def get_raw(identifier)
        directory.files.head(identifier)
      end

      def default_expires_in
        1.minute
      end

      def get_url(_report)
        raise NotImplementedError
      end
    end
  end
end
