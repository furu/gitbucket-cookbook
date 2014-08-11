#
# Cookbook Name:: gitbucket-cookbook
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'openjdk-7-jre-headless' do
  action :upgrade
end

package 'tomcat7' do
  action :upgrade
end

ENV['JAVA_HOME'] = '/usr/lib/jvm/java-7-openjdk-amd64'

service 'tomcat7' do
  action [:enable, :start]
  supports restart: true
end

GITBUCKET_DIR = '/var/lib/gitbucket'

directory GITBUCKET_DIR do
  action :create
  owner 'tomcat7'
  group 'tomcat7'
end

link '/usr/share/tomcat7/.gitbucket' do
  to GITBUCKET_DIR
end

GITBUCKET_DOWNLOAD_URL = 'https://github.com/takezoe/gitbucket/releases/download/2.2.1/gitbucket.war'

remote_file '/var/lib/tomcat7/webapps/gitbucket.war' do
  action :create_if_missing
  source GITBUCKET_DOWNLOAD_URL
  notifies :restart, 'service[tomcat7]'
end
