module Adhoq
  module Storage
    autoload 'FogStorage', 'adhoq/storage/fog_storage'
    autoload 'LocalFile',  'adhoq/storage/local_file'
    autoload 'S3',         'adhoq/storage/s3'
    autoload 'Google',     'adhoq/storage/google'
    autoload 'OnTheFly',   'adhoq/storage/on_the_fly'
    autoload 'Cache',      'adhoq/storage/cache'

    def with_new_identifier(prefix: nil, suffix: nil, seed: Time.now)
      dirname, fname_seed = ['%Y-%m-%d', '%H%M%S.%L'].map { |f| seed.strftime(f) }

      basename = format('%s%s_%05d%s', prefix, fname_seed, Process.pid, suffix)

      [dirname, basename].join('/').tap { |id| yield id }
    end
    module_function :with_new_identifier
  end
end
