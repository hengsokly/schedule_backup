ENV.each_key do |key|
  env key.to_sym, ENV[key]
end

set :output, "/var/log/cron.log"

# For backup database
every (ENV["BACKUP_PERIOD"] || 1).to_i.day do
  command "bundle exec backup perform -t db_backup"
end
