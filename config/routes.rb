Rails.application.routes.draw do
  root 'users#index'
  post '/lenders' => 'lenders#create' #reads create method in lenders controller
  post '/borrowers' => 'borrowers#create'
  get '/online_lending/lender/login' => 'lender_sessions#index'
  get '/online_lending/lender/:id' => 'lenders#show'
  get '/online_lending/borrower/login' => 'borrower_sessions#index'
  get '/online_lending/borrower/:id' => 'borrowers#show'
  post '/lender/sessions' => 'lender_sessions#create'
  post '/borrower/sessions' => 'borrower_sessions#create'
  delete '/lenders/sessions' => 'lender_sessions#destroy'
  delete '/borrowers/sessions' => 'borrower_sessions#destroy'
  post '/transactions' => 'lenders#transaction'

end
