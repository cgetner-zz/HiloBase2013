# coding: UTF-8

Hilo::Application.routes.draw do

  #get "hilo_search/index"
  resources :hilo_search do
    post 'create_guest_job_seeker'
    post 'save_employer_work_env_questions'
    get 'pairing_results'
    get 'employer_pairing_results', :on => :collection
    post 'location_graph'
    post 'birkman_graph'
    post 'role_cluster_graph'
  end

  match 'sitemap.xml' => 'sitemaps#sitemap'

  root :to => 'employer#index'
  match '/career_seeker' , :controller => 'home', :action => 'index', :as => "career_seeker"
  match '/career_seeker_bridge' , :controller => 'home', :action => 'career_seeker_bridge', :as => "career_seeker_bridge"
  match 'position_profile/xref/:cs_id' , :controller => 'position_profile', :action => 'xref'
  match 'job/:job_id/:platform_id', :controller => 'job', :action=>"index" #used for bridge
  match 'job/:company_name/:job_name/:job_id/:platform_id', :controller => 'job', :action=>"index" #used for bridge
  match 'company_bridge/:company_id/:platform_id', :controller => 'company_postings', :action=>"index" #used for bridge
  match ':company_name/internal_candidate/:company_id/:random_token', :controller => 'company_internal_candidates', :action=>"index"
  match 'company/:company_name/:company_id/:platform_id', :controller => 'company_postings', :action=>"index" #used for bridge
  match 'authenticate/:token', :controller=>"login", :action=>"email_verify"
  match 'job_feed/:id', :controller=>"job_feed", :action=>"index"
  #START: All routes for administrator module defined here
  namespace :admin do |admin|
    root :to => 'home#index'

    resources :home do
      collection do
        get 'index'
        get 'referral_fee'
        get 'account'
        get 'corporate_account'
        get 'search_company'
        get 'validate_email'
        get 'delete_corp_account'
        get 'new_admin_email_presence'
        get 'authorize_admin_access'
        get 'generate_promo_codes'
        get 'career_seeker'
        get 'employer_delete_request'
        get 'right_management'
        post 'grant_right_authentication'
        post 'revoke_right_authentication'
        post 'add_to_privileged_list'
        post 'remove_from_privileged_list'
        post 'change_password'
        post 'referral_fee_data'
        post 'privileged_list_history'
        post 'mark_as_paid'
        post 'create_new_employer_account'
        post 'create_admin'
        post 'revoke_email_domain_authentication'
        post 'grant_email_domain_authentication'
        post 'admin_employer_delete_cancel'
        post 'admin_job_seeker_delete_cancel'
        post 'admin_employer_delete'
        post 'admin_job_seeker_delete'
        post 'delete_job_seeker'
        post 'delete_employer'
        post 'refresh_table'
      end
    end
    resources :login do
      collection do
        get 'index'
        post 'authenticate_administrator'
      end
    end
  end
  #END: All routes for administrator module defined here

  match ':controller(/:action(/:id))'

  resources :login do
    collection do
      post 'login'
      get 'logout'
    end
  end

  resources :access_code do
    collection do
      post 'send_email'
      post 'resend_email'
    end
  end

  resources :forget_pwd do
    collection do
      post 'index'
      post 'change_password'
    end
  end

  resources :account do
    collection do
      get 'index'
      get 'opportunities'
    end
  end

end