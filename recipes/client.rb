# Author:: Ross Smith (<rjsm@umich.edu>)
# Cookbook Name:: caen-infra
# Recipe:: minion
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


#drop file to unregister at shutdown
file "/etc/rc.d/init.d/salt_unregister" do
  owner 'root'
  group 'root'
  mode  '0755'
end

service 'salt_unregister' do
  action [:enable ]
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
#setup ganglia/monitoring 
#

