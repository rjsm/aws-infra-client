# Author:: Ross Smith (<rjsm@umich.edu>)
# Cookbook Name:: caen-client
# Recipe:: configure
#
# Apache 2.0
#

#
#setup salt minion 
#
yum_package "salt-minion" do
  action :upgrade
end

service 'salt-minion' do
  action [:enable, :start] 
end

#drop config file
template "/etc/salt/minion" do
  source 'minion.erb'
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, 'service[salt-minion]', :delayed
  # notifies :run, 'execute[wait for salt-minion]', :delayed
end


#
#setup syslog monitoring
#
file "/etc/rsyslog.conf" do
  owner 'root'
  group 'root'
  mode  '600'
  action :create
end

#
# setup yum-cron-security
#
yum_package "yum-cron-security" do
  action :upgrade
end

file "/etc/yum/yum-cron-security.conf" do
  owner 'root'
  group 'root'
  mode  '644'
end
#
#setup ganglia/monitoring 
#

