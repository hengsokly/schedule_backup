ENV.each_key do |key|
  env key.to_sym, ENV[key]
end

set :output, "#{path}/Backup/log/backup.log"
set :environment, ENV["RAILS_ENV"]

# For backup database
every 1.hour do
  command "backup perform -t db_backup"
end
