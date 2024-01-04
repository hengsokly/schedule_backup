ENV.each_key do |key|
  env key.to_sym, ENV[key]
end

set :output, "/var/log/cron.log"

# For backup database
# Read more on https://help.ubuntu.com/community/CronHowto
every ENV.fetch("CRON_SYNTAX") { "0 0 * * *" } do
  command "bundle exec backup perform -t db_backup"
end
