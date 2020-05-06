module Adhoq
  module Storage
    class OnTheFly
      PREFIX = 'memory://adhoq-on-the-fly'.freeze

      attr_reader :identifier, :reports

      def initialize(id_base = Process.pid)
        @identifier = "#{PREFIX}-#{id_base}"
        @reports    = {}
      end

      def store(suffix = nil, seed = Time.now)
        Adhoq::Storage.with_new_identifier(suffix, seed) do |identifier|
          @reports[identifier] = yield.tap(&:rewind)
        end
      end

      def direct_download?
        false
      end

      def get(identifier)
        item = @reports.delete(identifier)
        return unless item

        item.read.tap { item.close }
      end
    end
  end
end
