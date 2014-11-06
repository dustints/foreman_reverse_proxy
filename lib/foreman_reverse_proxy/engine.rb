require 'deface'

module ForemanReverseProxy
  class Engine < ::Rails::Engine
    isolate_namespace ForemanReverseProxy

    config.autoload_paths += Dir["#{config.root}/lib"]
    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer "foreman_reverse_proxy.load_app_instance_data" do |app|
      app.config.paths['db/migrate'] +=
        ForemanReverseProxy::Engine.paths['db/migrate'].existent
    end

    initializer 'foreman_reverse_proxy.register_plugin',
                                :after => :finisher_hook do
      Foreman::Plugin.register :foreman_reverse_proxy do
        requires_foreman '>= 1.3'

        require 'foreman_reverse_proxy/foreman_url_provider'
        override_foreman_url ForemanReverseProxy::ForemanUrlProvider.new

        # Add permissions
        security_block :foreman_reverse_proxy do
          permission :view_foreman_reverse_proxy,
            :'foreman_reverse_proxy/hosts' => [:new_action]
        end
      end
    end

    #Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanReverseProxy::HostExtensions)
        HostsHelper.send(:include, ForemanReverseProxy::HostsHelperExtensions)
      rescue => e
        Rails.logger.debug "ForemanReverseProxy: skipping engine hook (#{e})"
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanReverseProxy::Engine.load_seed
      end
    end
  end
end
