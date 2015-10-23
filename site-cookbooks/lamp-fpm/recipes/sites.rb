#
# Cookbook Name:: lamp-fpm
# Recipe:: sites
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "lamp-fpm::default"

def build_php_environment site
	unless site['mysql_password']
		Chef::Application.fatal!("site mysql_password should be specified in node attributes")
	end

	php_environment site['application_name'] do
		server_name site['server_name']
		server_aliases site['server_aliases']
		mysql_password site['mysql_password']
	end
end

if node['lamp-fpm']['sites'].kind_of? Hash
	build_php_environment node['lamp-fpm']['sites']
elsif node['lamp-fpm']['sites'].kind_of? Array
	node['lamp-fpm']['sites'].each do |site|
		build_php_environment site
	end
end

