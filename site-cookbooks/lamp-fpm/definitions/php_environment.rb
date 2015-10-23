define :php_environment, :server_name => nil do
	servername = params[:server_name] || params[:name] + ".local"

	user params[:name] do
		action :create

		supports :manager_home => true
		manage_home true

		home "/home/#{params[:name]}"
		shell '/bin/bash'
	end

	directory "/home/#{params[:name]}/public_html" do
		action :create

		owner params[:name]
	end

	web_app params[:name] do
		template 'web_app.conf.erb'
		
		server_name servername

		allow_override 'All'
	end

	connection_info = {
		:host => '127.0.0.1',
		:username => 'root',
		:password => 'cXSjjAP82'
	}


	mysql_database params[:name] do
		connection connection_info

		action :create
	end

	mysql_database_user params[:name] do
		connection connection_info

		password 'vXJ28SpxLq'
		action :create
	end

	mysql_database_user params[:name] do
		connection connection_info

		database_name params[:name] 
		privileges [:all]

		action :grant
	end

	mysql_database params[:name] do
		connection connection_info

		sql        'flush privileges'
		action     :query
	end

	php_fpm_pool params[:name] do
		process_manager "dynamic"

		max_requests 1000
		max_children 30
		max_spare_servers 30
		start_servers 10

		user params[:name]
		group params[:name]

		php_options 'php_admin_flag[log_errors]' => 'on', 'php_admin_value[memory_limit]' => '32M'
	end
end