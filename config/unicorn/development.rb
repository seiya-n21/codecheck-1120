# coding: utf-8

application = 'meetil'
shared_path = "/var/www/#{application}/shared"

worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
working_directory "/var/www/#{application}/current"
timeout 30
preload_app true

listen "#{shared_path}/tmp/sockets/unicorn.sock"
pid "#{shared_path}/tmp/pids/unicorn.pid"

stderr_path "#{shared_path}/log/unicorn-stderr.log"
stdout_path "#{shared_path}/log/unicorn-stdout.log"

# before_fork do |server, worker|
before_fork do |server|
  # マスタープロセスの接続を解除
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)

  # 古いマスタープロセスをKILL
  old_pid = "#{shared_path}/tmp/pids/unicorn.pid.oldbin"
  Process.kill("QUIT", File.read(old_pid).to_i) if File.exist?(old_pid) && server.pid != old_pid
end

# after_fork do |server, worker|
after_fork do
  # preload_app=trueの場合は必須
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)
end
