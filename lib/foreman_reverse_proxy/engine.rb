require 'deface'

module ForemanReverseProxy
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer "foreman_reverse_proxy.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] += ForemanReverseProxy::Engine.paths['db/migrate'].existent
    end

    initializer 'foreman_reverse_proxy.register_plugin', :after=> :finisher_hook do |app|
      Foreman::Plugin.register :foreman_reverse_proxy do
        requires_foreman '>= 1.4'

        # Add permissions
        security_block :foreman_reverse_proxy do
          permission :view_foreman_reverse_proxy, {:'foreman_reverse_proxy/hosts' => [:new_action] }
        end

        # Add a new role called 'Discovery' if it doesn't exist
        role "ForemanReverseProxy", [:view_foreman_reverse_proxy]

        #add menu entry
        menu :top_menu, :template,
             :url_hash => {:controller => :'foreman_reverse_proxy/hosts', :action => :new_action },
             :caption  => 'ForemanReverseProxy',
             :parent   => :hosts_menu,
             :after    => :hosts

        # add dashboard widget
        widget 'foreman_reverse_proxy_widget', :name=>N_('Foreman plugin template widget'), :sizex => 4, :sizey =>1
      end
    end

    #Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanReverseProxy::HostExtensions)
        HostsHelper.send(:include, ForemanReverseProxy::HostsHelperExtensions)
      rescue => e
        puts "ForemanReverseProxy: skipping engine hook (#{e.to_s})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanReverseProxy::Engine.load_seed
      end
    end

  end
end
