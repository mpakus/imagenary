#setup user environment
ENV['RAILS_ENV'] = 'production'
worker_processes 2
preload_app true
user('deployer','staff')
timeout 30

@app = "/home/deployer/imagenary/current"
@shared = "/home/deployer/imagenary/shared"

listen "#{@shared}/tmp/unicorn.socket"
working_directory "#{@app}"
pid "#{@shared}/tmp/unicorn.pid"
stderr_path "#{@shared}/log/unicorn.stderr.log"
stdout_path "#{@shared}/log/unicorn.stdout.log"

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  Rails.cache.reset if Rails.cache.respond_to? :reset

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
  #worker.user('rails', 'rails') if Process.euid == 0 && rails_env == 'production'
end