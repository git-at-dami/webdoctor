# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'application#home'

  scope ':user_type', constraints: { user_type: /patient|doctor|admin/ } do
    resources :messages do
      member do # Use 'member' for routes related to a specific message
        get :order, to: 'messages#reissue_prescription', as: :reissue_prescription
      end
    end
  end
end
