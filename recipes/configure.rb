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

# try to set tags
ruby_block "set-tags" do
  block do
    require 'aws-sdk'

    AWS.config(region: node["opsworks"]["instance"]["region"])

    inst = AWS::EC2::Instance.new(node["opsworks"]["instance"]["aws_instance_id"])
    inst.tag('Shortcode', :value => node["caen"]["Shortcode"])
    inst.tag('Purpose', :value => node["caen"]["Purpose"])
    inst.tag('Role', :value => node["caen"]["Role"])
    inst.tag('Owner', :value => node["caen"]["Owner"])

    puts inst.root_device_type() 
# the following commented section is for the v2 sdk, which while the officially supported version,
# doesn't work in opsworks...
#   ec2 = AWS::EC2::Resource.new(region:node["opsworks"]["instance"]["region"])
#   inst = ec2.instance(node["opsworks"]["instance"]["aws_instance_id"])
#   inst.create_tags({ dry_run: false,
#                      tags: [ { key: "Shortcode", value: node["caen"]["Shortcode"],},
#                              { key: "Purpose", value: node["caen"]["Purpose"],},
#                              { key: "Role", value: node["caen"]["Role"],},
#                              { key: "Owner", value: node["caen"]["Owner"],}, ], } )
  end
  action :run
end

