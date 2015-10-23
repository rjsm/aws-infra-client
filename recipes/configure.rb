# Author:: Ross Smith (<rjsm@umich.edu>)
# Cookbook Name:: caen-client
# Recipe:: configure
#
# Apache 2.0
#

# get file from bucket
ruby_block "download-object" do
  block do
    require 'aws-sdk'

    s3 = AWS::S3.new

    myfile = s3.buckets['linuxinfrastructure-files'].objects['ansible-files/packages/ansible-1.9.4-2.amzn1.noarch.rpm']
    Dir.chdir("/tmp")
    File.open("ansible.rpm", "w") do |f|
      f.syswrite(myfile.read)
      f.close
    end
  end
  action :run
end

# install ansible from our package
yum_package "ansible" do
  source "/tmp/ansible.rpm"
  action :upgrade
end

#drop config file
template "/etc/cron.d/ansible-pull" do
  source 'pull.erb'
  owner "root"
  group "root"
  mode "0644"
end
