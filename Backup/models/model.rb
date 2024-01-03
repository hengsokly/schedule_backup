# encoding: utf-8

##
# Backup Generated: db_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t db_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
require 'uri'

DATABASE_URL = URI.parse ENV['DATABASE_URL']

Model.new(:db_backup, 'Backup database') do
  database PostgreSQL do |db|
    db.name               = DATABASE_URL.path.delete('/')
    db.username           = DATABASE_URL.user
    db.password           = DATABASE_URL.password
    db.host               = DATABASE_URL.host
    db.port               = DATABASE_URL.port || 5432
    # db.socket             = "/tmp/pg.sock"
    # When dumping all databases, `skip_tables` and `only_tables` are ignored.
    # db.skip_tables        = ['skip', 'these', 'tables']
    # db.only_tables        = ['only', 'these' 'tables']
    db.additional_options = []
  end

  if ENV['STORAGE_TYPE'] == "AWS3"
    ##
    # AWS3 [Storage]
    #
    store_with S3 do |s3|
      # AWS Credentials
      s3.access_key_id     = ENV["AWS_ACCESS_KEY_ID"]
      s3.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
      # Or, to use a IAM Profile:
      # s3.use_iam_profile = true

      s3.region             = ENV["AWS_REGION"]
      s3.bucket             = ENV["AWS_NAME_OF_DB_BUCKET"]
      s3.path               = ENV["AWS_PATH_TO_DB_BACKUP"]
    end
  else
    ##
    # Local (Copy) [Storage]
    #
    store_with Local do |local|
      local.path       = "/root/backups/"
      local.keep       = 5
      # local.keep       = Time.now - 2592000 # Remove all backups older than 1 month.
    end
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip
end
