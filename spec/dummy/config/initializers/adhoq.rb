Adhoq.configure do |c|
  c.base_controller    = 'MyApplicationController'
  c.authorization      = :adhoq_authorized?
  c.current_user       = :current_user
  c.storage            = [:local_file, Rails.root + "./tmp/adhoq/#{Rails.env}"]
=begin
  # S3 setting example
  c.storage       = [
    :s3,
    'moro-test',
    {
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region:               'us-east-1'
    }
  ]

  # Google setting example
  c.storage       = [
    :google,
    ENV['GOOGLE_STORAGE_REPORTING_BUCKET'] || 'my-bucket',
    {
      google_storage_key_id:     ENV['GOOGLE_STORAGE_ACCESS_KEY_ID'],
      google_storage_access_key: ENV['GOOGLE_STORAGE_SECRET_ACCESS_KEY'],
      region:                    'europe-west4'
    }
  ]
=end
end
