CarrierWave.configure do |config|

  config.storage              = :grid_fs
  config.grid_fs_access_url   = "/files"
  config.grid_fs_database     = Mongoid.database.name if Rails.env.development? or !ENV['HEROKU']

  if Rails.env.production? and ENV['HEROKU'] and (mongo = ENV['MONGOLAB_URI'] || ENV['MONGOHQ_URL'])
    settings = URI.parse(mongo)
    database_name = settings.path.gsub(/^\//, '')

    config.grid_fs_database   = database_name
    config.grid_fs_host       = settings.host
    config.grid_fs_port       = settings.port
    config.grid_fs_username   = settings.user
    config.grid_fs_password   = settings.password
  end
end
