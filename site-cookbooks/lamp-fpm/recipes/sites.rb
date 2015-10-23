#
# Cookbook Name:: lamp-fpm
# Recipe:: sites
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "lamp-fpm::default"

if node['lamp-fpm']['sites'].kind_of? String
	php_environment node['lamp-fpm']['sites']
elsif node['lamp-fpm']['sites'].kind_of? Hash
	php_environment node['lamp-fpm']['sites']['application_name'] do
		server_name node['lamp-fpm']['sites']['server_name']
	end
elsif node['lamp-fpm']['sites'].kind_of? Array
	node['lamp-fpm']['sites'].each do |site|
		php_environment site['application_name'] do
			server_name site['server_name']
		end
	end
end

