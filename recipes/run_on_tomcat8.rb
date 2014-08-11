#
# Cookbook Name:: gitbucket-cookbook
# Recipe:: run_on_tomcat8
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt'

apt_repository 'backports' do
  uri 'http://http.debian.net/debian'
  distribution 'wheezy-backports'
  components ['main']
end

package 'tomcat8' do
  action :upgrade
end

service 'tomcat8' do
  action [:enable, :start]
  supports restart: true
end

GITBUCKET_DIR = '/var/lib/gitbucket'

directory GITBUCKET_DIR do
  action :create
  owner 'tomcat8'
  group 'tomcat8'
end

link '/usr/share/tomcat8/.gitbucket' do
  to GITBUCKET_DIR
end

GITBUCKET_DOWNLOAD_URL = 'https://github.com/takezoe/gitbucket/releases/download/2.2.1/gitbucket.war'

remote_file '/var/lib/tomcat8/webapps/gitbucket.war' do
  action :create_if_missing
  source GITBUCKET_DOWNLOAD_URL
  notifies :restart, 'service[tomcat8]'
end
