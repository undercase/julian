class HomeController < ApplicationController
  def home
    if user_signed_in?
      redirect_to questions_path
    end
  end
end
