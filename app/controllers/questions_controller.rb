require 'twilio-ruby'

class QuestionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_question = current_user.questions.find_by(ready: true)
    @questions = Asker.where(ready: true, claimed: false).order(updated_at: :desc).limit(10)
  end
  def show
    @current_question = current_user.questions.find_by(ready: true)
    @question = Asker.find(params[:id])
    redirect_to questions_path unless @question
  end
  def claim
    @current_question = current_user.questions.find_by(ready: true)
    if @current_question
      redirect_to write_question_path(@current_question.id)
    else
      @question = Asker.find(params[:id])
      redirect_to questions_path if @question && @question.claimed

      @question.claimed = true
      @question.user = current_user
      @question.save
      redirect_to write_question_path(@question.id)
    end
  end
  def cancel
    @question = Asker.find(params[:id])
    redirect_to questions_path unless @question && @question == current_user.questions.find_by(ready: true)

    current_user.questions.delete(@question)
    @question.claimed = false
    @question.save
    
    redirect_to questions_path
  end
  def write
    @current_question = Asker.find(params[:id])
    redirect_to questions_path unless @current_question && @current_question == current_user.questions.find_by(ready: true)
  end
  def answer
    @question = Asker.find(params[:id])
    redirect_to questions_path unless @question && @question == current_user.questions.find_by(ready: true)

    if @question.update(question_params)
      @question.ready = false
      @question.answered = true
      @question.save

      account_sid = "AC1265ded4c0a478a8b1326261c07df987"
      from = "+18175672396"
      auth_token = "e99c96068f12983414bb8b19308e4909"

      client = Twilio::REST::Client.new account_sid, auth_token
      client.account.sms.messages.create(body: @question.answer, to: @question.number, from: from)
      current_user.questions.delete(@question)
      redirect_to questions_path
    else
      render 'write'
    end
  end

  private
    def question_params
      params.require(:question).permit(:answer)
    end
end