define :unicorn_init,
    :app_root     => nil,
    :pid          => nil,
    :config       => 30,
    :rails_env    => false,
    :owner                => nil,
    :group                => nil,
    :unicorn_user => 4  do

  template "/etc/init.d/" do
    source "unicorn_init.sh.erb"
    cookbook "unicorn"
    mode "0644"
    owner params[:owner] if params[:owner]
    group params[:group] if params[:group]
    mode params[:mode]   if params[:mode]
    variables params
    notifies *params[:notifies] if params[:notifies]
  end

  # If the user set a group for forked processes but not a user, warn them that
  # we did not set the group. Unicorn does not allow you to drop privileges at
  # the group level only.
  ruby_block "warn-group-no-user" do
    only_if { params[:forked_user].nil? and !params[:forked_group].nil? }
    block do
      Chef::Log.warn "Unable to set the Unicorn 'forked_group' because a "\
        "forked_user' was not specified! Unicorn will be run as root! Please "\
        "see the Unicorn documentation regarding `user` for proper usage."
    end
  end
end
