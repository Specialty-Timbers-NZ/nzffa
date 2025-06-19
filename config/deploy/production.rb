set :rails_env, 'production'
set :rack_env, rails_env
# set :bundle_cmd, '/home/fft-app/.rbenv/shims/bundle'
# set :whenever_command, "/home/fft-app/.rbenv/shims/bundle exec whenever"
set :branch, 'production'
set :user, 'fft-app'
set :deploy_to, "/home/#{user}/app"

set :solo_host, 'www-1.h.specialtytimbers.nz'
role :web, solo_host
role :app, solo_host
role :db,  solo_host, :primary => true
