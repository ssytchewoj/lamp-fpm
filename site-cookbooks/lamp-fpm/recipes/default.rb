#
# Cookbook Name:: lamp-fpm
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install Apache and required modules

include_recipe 'apache2'
include_recipe 'apache2::mod_rewrite'
include_recipe 'apache2::mod_fastcgi'
include_recipe 'apache2::mod_actions'
include_recipe 'apache2::mod_alias'

# Install MySQL 5.6

unless node['lamp-fpm']['mysql'] && node['lamp-fpm']['mysql']['initial_root_password'].kind_of?(String)
  Chef::Application.fatal!("initial_root_password should be specified in node attributes")
end

mysql_service 'default' do
  port '3306'
  version '5.6'
  initial_root_password node['lamp-fpm']['mysql']['initial_root_password']
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end

gem_package "mysql2" do
  action :install
end

# Setup PHP-FPM

include_recipe 'php-fpm'

['php5-mysql', 'php5-apcu'].each do |pkg|
  package pkg do
    notifies :restart, "service[php-fpm]"
  end
end