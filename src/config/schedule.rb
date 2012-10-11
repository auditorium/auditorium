set :output, "/srv/webapps/auditorium/logs/cron.log"

every 2.hours do
  rake "thinking_sphinx:index"
end

every :reboot do
  rake "thinking_sphinx:start"
end
