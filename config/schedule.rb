# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

#NOTE I should manually set @environment for development
#set :environment, 'development'

case @environment
when 'production'
  path = "$HOME/.rbenv/shims:$HOME/.rbenv/bin:/usr/bin:$PATH"
when 'development'
  path = "/usr/local/opt/rbenv/shims:/usr/local/opt/rbenv/bin:/usr/bin:$PATH"
end

job_type :rbenv_rake, %Q{export PATH=#{path}; eval "$(rbenv init -)"; \
                       cd :path && bundle exec rake :task --silent :output }

every 1.day, at: '12:00 am' do
  rbenv_rake 'mail_watcher:check_and_deliver'
end
