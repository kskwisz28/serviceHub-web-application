Rails.application.routes.draw do

  resources :users, only: :update
  resource :instruments, only: :show
  resource :instrumentskus, only: :show
  get 'list_instruments' => 'instruments#index'
  get 'list_instrumentskus' => 'instrumentskus#index'
  resource :literature, only: :show
  get 'leads_pass' => 'leads_pass#new'
  post 'leads_pass' => 'leads_pass#create'
  get 'leads_pass/models' => 'leads_pass#models'
  get 'leads_pass/placeholder' => 'leads_pass#placeholder'
  get 'leads_pass/instrument_image' => 'leads_pass#instrument_image'
  
  get 'reverse_leads_pass' => 'reverse_leads_pass#new'
  post 'reverse_leads_pass' => 'reverse_leads_pass#create'
  get 'reverse_leads_pass/models' => 'reverse_leads_pass#models'
  get 'reverse_leads_pass/placeholder' => 'reverse_leads_pass#placeholder'
  get 'reverse_leads_pass/instrument_image' => 'leads_pass#instrument_image'

  get 'faq' => 'faq#show'
  get 'lsg_lifecycle_status' => 'lsg_lifecycle_status#show'
  resource :email_message, only: [:show, :update]
  resource :feedback_email_message
  get 'email_message/thank_you' => 'email_messages#thank_you'
  resources :countries, only: :index

  get 'login' => 'login#new'
  root 'instruments#show'
  namespace :admins do
    root to: redirect("/admins/home")
    resource :home, only: [:show]
    resource :alert_bar, only: [:show, :create, :destroy]
  end


  get 'dev/emails/default' => 'dev#show_default_email'
  get 'dev/emails/default_feedback' => 'dev#show_default_feedback_email'
  get 'dev/emails/default_leads_pass' => 'dev#show_default_leads_pass_email'
  if Rails.env.development?
    post 'dev/ms_graph_send_mail' => 'dev#send_mail'
  end
end
