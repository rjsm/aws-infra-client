# Author:: Ross Smith (<rjsm@umich.edu>)
# Cookbook Name:: caen-infra
# Recipe:: shutdown
#
# Apache 2.0
#

#
#setup salt minion 
#
# unregister client from master
execute "unregister" do
  command "salt-call saltutil.revoke_auth"
end
