Rails.application.routes.draw do

  match 'new_action', :to => 'foreman_reverse_proxy/hosts#new_action'

end
