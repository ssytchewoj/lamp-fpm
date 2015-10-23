#
# Cookbook Name:: lamp-fpm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Create web-user

user 'joomla' do
	action :create

	supports :manager_home => true
	manage_home true

	home '/home/joomla'
	shell '/bin/bash'
end

directory '/home/joomla/public_html' do
  action :create

  owner 'joomla'
end

# Install Apache and required modules

include_recipe 'apache2'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_fastcgi'
include_recipe 'apache2::mod_actions'
include_recipe 'apache2::mod_alias'

web_app "joomla" do
   template 'web_app.conf.erb'
   server_name 'joomlaserver'
   docroot  '/home/joomla/public_html'
   allow_override 'All'
end

# Install MySQL 5.6

mysql_service 'default' do
  port '3306'
  version '5.6'
  initial_root_password 'cXSjjAP82'
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end

# Setup MySQL DB for user

gem_package "mysql2" do
  action :install
end

connection_info = {
  :host => '127.0.0.1',
  :username => 'root',
  :password => 'cXSjjAP82'
}

mysql_database 'joomla' do
  connection connection_info

  action :create
end

mysql_database_user 'joomla' do
  connection connection_info

  password 'vXJ28SpxLq'
  action :create
end

mysql_database_user 'joomla' do
  connection connection_info

  database_name 'joomla' 
  privileges [:all]

  action :grant
end

mysql_database 'joomla' do
  connection connection_info

  sql        'flush privileges'
  action     :query
end

# Setup PHP-FPM

include_recipe 'php-fpm'

php_fpm_pool "joomla" do
  process_manager "dynamic"

  max_requests 1000
  max_children 30
  max_spare_servers 30
  start_servers 10
  
  user 'joomla'
  group 'joomla'

  php_options 'php_admin_flag[log_errors]' => 'on', 'php_admin_value[memory_limit]' => '32M'
end

['php5-mysql', 'php5-apcu'].each do |pkg|
  package pkg do
    notifies :restart, "service[php-fpm]"
  end
end

