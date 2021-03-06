#
# Cookbook Name:: rubygems-chef
# Recipe:: default
#

node.default['chef_client']['config']['ssl_verify_mode'] = ':verify_peer'
node.default['chef_client']['config']['client_fork'] = true

# This is due to new ohai cookbook, TODO: find out what the right thing is
node.default['ohai']['plugin_path'] = '/etc/chef/ohai_plugins'

node.default['chef_client']['init_style'] = 'none'
node.default['chef_client']['cron']['minute'] = '*/15'
node.default['chef_client']['cron']['hour'] = '*'

include_recipe 'chef-client::config'

include_recipe 'rubygems-chef::slack'

# See: https://github.com/opscode-cookbooks/chef-client/issues/196
if node.name == 'chef.common.rubygems.org'
  r = resources(template: '/etc/chef/client.rb')
  r.user 'root'
  r.group 'root'
end

include_recipe 'chef-client::cron'

chef_client_updater 'Install Chef 12.17.44' do
  version '12.17.44'
end
