ENV.each_key do |key|
  env key.to_sym, ENV[key]
end

set :output, "#{path}/Backup/log/backup.log"
set :environment, ENV["RAILS_ENV"]

# For backup database
# every 1.hour do
every 1.minute do
  command "bundle exec backup perform -t db_backup"
end
