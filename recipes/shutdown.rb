# Author:: Ross Smith (<rjsm@umich.edu>)
# Cookbook Name:: caen-client
# Recipe:: shutdown
#
# Apache 2.0
#

#
#setup salt minion 
#
# unregister client from master
execute "unregister" do
  command "salt-call event.fire_master '{}' caen-tag/key/delete"
end
