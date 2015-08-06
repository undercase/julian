Rails.application.routes.draw do
  devise_for :users
  root 'home#home'

  # Texting
  post 'text' => 'text#text'

  # Tutors
  get 'questions' => 'questions#index', as: :questions
  get 'questions/:id' => 'questions#show', as: :question
  post 'questions/:id/claim' => 'questions#claim', as: :claim_question
  delete 'questions/:id/cancel' => 'questions#cancel', as: :cancel_question
  get 'questions/:id/write' => 'questions#write', as: :write_question
  post 'questions/:id/answer' => 'questions#answer', as: :answer_question
end
