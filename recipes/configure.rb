# Author:: Ross Smith (<rjsm@umich.edu>)
# Cookbook Name:: caen-client
# Recipe:: configure
#
# Apache 2.0
#

#
#setup salt minion 
#
yum_package "ansible" do
  action :upgrade
end

#drop config file
template "/etc/cron.d/ansible-pull" do
  source 'pull.erb'
  owner "root"
  group "root"
  mode "0644"
end
