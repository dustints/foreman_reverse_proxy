module ForemanReverseProxy

  # Example: Plugin's HostsController inherits from Foreman's HostsController
  class HostsController < ::HostsController

    # change layout if needed
    # layout 'foreman_reverse_proxy/layouts/new_layout'

    def new_action
      # automatically renders view/foreman_reverse_proxy/hosts/new_action
    end

  end
end
