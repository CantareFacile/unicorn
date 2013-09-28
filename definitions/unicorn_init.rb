define :unicorn_init,
    :app_root     => nil,
    :pid          => nil,
    :config       => nil,
    :rails_env    => nil,
    :unicorn_user => nil  do

  service "#{params[:name]}_unicorn" do
    supports restart: true, start: true, stop: true, reload: true
    action :nothing
  end

  template "/etc/init.d/#{params[:name]}_unicorn" do
    source "unicorn_init.sh.erb"
    cookbook "unicorn"
    owner 'root'
    group 'root'
    mode '0755'
    variables params
  end
end
