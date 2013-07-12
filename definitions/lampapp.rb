define :lampapp, :template => "lampapp.conf.erb" do

  app_name = params[:name]

  template "#{node['apache']['dir']}/sites-available/#{app_name}.conf" do
    source params[:template]
    owner "root"
    group node['apache']['root_group']
    mode 0644
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
      :name => app_name,
      :params => params
    )
    if ::File.exists?("#{node['apache']['dir']}/sites-enabled/#{app_name}.conf")
      notifies :reload, resources(:service => "apache2"), :delayed
    end
  end

  apache_site "#{app_name}.conf" do
    enable true
  end
end
