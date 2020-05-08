require 'fog/google'

module Adhoq
  module Storage
    class Google < FogStorage
      attr_reader :bucket, :direct_download, :direct_download_options, :expires_in, :google

      def initialize(bucket, google_options = {})
        @bucket                  = bucket
        @direct_download         = google_options.delete(:direct_download)
        @direct_download_options = google_options.delete(:direct_download_options) || default_direct_download_options
        @expires_in              = google_options.delete(:expires_in) || default_expires_in
        @google = Fog::Storage.new({ provider: 'Google' }.merge(google_options))
      end

      def direct_download?
        direct_download
      end

      def identifier
        "gs://#{bucket}"
      end

      def get_url(report)
        get_raw(report.identifier).url(
          expires_in.from_now.to_i,
          direct_download_options.call(report)
        )
      end

      private

      def directory
        return @directory if @directory

        @directory = google.directories.get(bucket) || google.directories.create(key: bucket, public: false)
      end

      def default_direct_download_options
        proc do |report|
          value = URI.encode_www_form_component(report.name)
          {
            query: {
              'response-content-disposition' => "attachment; filename*=UTF-8''#{value}",
              'response-content-type' => report.mime_type
            }
          }
        end
      end
    end
  end
end
