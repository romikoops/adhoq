# rubocop:disable Metrics/ModuleLength
module Adhoq
  RSpec.describe Storage, type: :model do
    describe Storage::FogStorage do
      let(:storage) { Storage::FogStorage.new }

      specify { expect(storage.default_expires_in).to eq 1.minute }
      specify { expect(storage.direct_download?).to eq false }

      specify do
        expect { storage.get_url(nil) }.to raise_error(NotImplementedError)
        expect { storage.send(:directory) }.to raise_error(NotImplementedError)
      end
    end

    describe Storage::LocalFile do
      tempdir = __dir__ + '/../../tmp/adhoq_storage.test'

      after(:all) do
        FileUtils.rm_rf(tempdir)
      end

      let(:storage) { Storage::LocalFile.new(tempdir) }

      let(:identifier) do
        storage.store(suffix: '.txt') { StringIO.new("Hello adhoq!\n") }
      end
      let(:identifier_with_prefix) do
        storage.store(prefix: 'prefix_', suffix: '.txt') { StringIO.new("Hello prefix!\n") }
      end

      specify { expect(storage.get(identifier)).to eq "Hello adhoq!\n" }
      specify { expect(storage.get(identifier_with_prefix)).to eq "Hello prefix!\n" }

      specify do
        expect { storage.get_url(nil) }.to raise_error(NotImplementedError)
      end
    end

    describe Storage::S3, :fog_mock do
      let(:storage) do
        Storage::S3.new(
          'my-adhoq-bucket',
          aws_access_key_id: 'key_id',
          aws_secret_access_key: 'access_key',
          direct_download: true,
          expires_in: 1.day
        )
      end

      let(:identifier) do
        storage.store(suffix: '.txt') { StringIO.new("Hello adhoq!\n") }
      end
      let(:identifier_with_prefix) do
        storage.store(prefix: 'prefix_', suffix: '.txt') { StringIO.new("Hello prefix!\n") }
      end

      specify do
        expect(storage.bucket).to eq 'my-adhoq-bucket'
        expect(storage.direct_download).to eq true
        expect(storage.direct_download?).to eq true
        expect(storage.direct_download_options).to be_a(Proc)
        expect(storage.expires_in).to eq 1.day
        expect(storage.s3).to be_a(Fog::AWS::Storage::Mock)
      end

      specify { expect(storage.get(identifier)).to eq "Hello adhoq!\n" }
      specify { expect(storage.get(identifier_with_prefix)).to eq "Hello prefix!\n" }
    end

    describe Storage::Google, :fog_mock do
      let(:storage) do
        Storage::Google.new(
          'my_adhoq_bucket',
          google_storage_access_key_id: 'key_id',
          google_storage_secret_access_key: 'access_key',
          direct_download: true,
          expires_in: 1.day
        )
      end

      let(:identifier) do
        storage.store(suffix: '.txt') { StringIO.new("Hello adhoq!\n") }
      end
      let(:identifier_with_prefix) do
        storage.store(prefix: 'prefix_', suffix: '.txt') { StringIO.new("Hello prefix!\n") }
      end

      specify do
        expect(storage.bucket).to eq 'my_adhoq_bucket'
        expect(storage.direct_download).to eq true
        expect(storage.direct_download?).to eq true
        expect(storage.direct_download_options).to be_a(Proc)
        expect(storage.expires_in).to eq 1.day
        expect(storage.google).to be_a(Fog::Storage::GoogleXML::Mock)
      end

      specify { expect(storage.get(identifier)).to eq "Hello adhoq!\n" }
      specify { expect(storage.get(identifier_with_prefix)).to eq "Hello prefix!\n" }
    end

    describe Storage::OnTheFly do
      let(:storage) { Storage::OnTheFly.new }

      let!(:identifier) do
        storage.store(suffix: '.txt') { StringIO.new("Hello adhoq!\n") }
      end
      let(:identifier_with_prefix) do
        storage.store(prefix: 'prefix_', suffix: '.txt') { StringIO.new("Hello prefix!\n") }
      end

      specify { expect(storage.get(identifier)).to eq "Hello adhoq!\n" }
      specify { expect(storage.get(identifier_with_prefix)).to eq "Hello prefix!\n" }

      specify do
        expect { storage.get_url(nil) }.to raise_error(NotImplementedError)
      end

      specify do
        expect { storage.get(identifier) }.to change { storage.reports.size }.by(-1)
      end
    end

    describe Storage::Cache do
      let(:storage) { Storage::Cache.new(Mock::Cache.new) }

      let!(:identifier) do
        storage.store(suffix: '.txt') { StringIO.new("Hello adhoq!\n") }
      end
      let(:identifier_with_prefix) do
        storage.store(prefix: 'prefix_', suffix: '.txt') { StringIO.new("Hello prefix!\n") }
      end

      specify { expect(storage.get(identifier)).to eq "Hello adhoq!\n" }
      specify { expect(storage.get(identifier_with_prefix)).to eq "Hello prefix!\n" }

      specify do
        expect { storage.get_url(nil) }.to raise_error(NotImplementedError)
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
