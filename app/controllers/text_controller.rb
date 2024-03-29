require 'twilio-ruby'

class TextController < TwilioController
  skip_before_action :verify_authenticity_token, except: [:start]

  def start
    account_sid = "AC012d54c42630a38d4c690396eacfedb3"
    from = "+15084449679"
    auth_token = "1275a64353e473cb11072470ce456176"
    body = "Hi - I'm Julian, your on demand tutor! Text me at this number to get instant homework help."

    client = Twilio::REST::Client.new account_sid, auth_token
    client.messages.create(body: body, to: params[:To].to_s, from: from)
    redirect_to root_path
  end
  def text
    asker = Asker.find_by(number: params[:From].to_s)
    if asker
      if asker.answered
        response = create_response("If you'd like to ask another question, text it to me ending with '?'!")
        asker.claimed, asker.answered = false, false
        asker.ready = false
        asker.question = nil
        asker.answer = nil
        asker.save
      elsif asker.question
        response = create_response("Please wait patiently for the answer to your question! I'm working on it right now.")
      else
        if params[:Body][-1] == "?"
          asker.question = params[:Body]
          asker.ready = true
          response = create_response("I've received your question, \"#{params[:Body]}\". I'm working on finding the answer right now.")
          asker.save
        else
          response = create_response("If you're asking a question, make sure it ends with '?'!")
        end
      end
    elsif params[:From]
      Asker.create(number: params[:From].to_s)
      response = create_response("Hi! My name's Julian - I'm your personal homework tutor. Just text me a question ending with a '?' at the end, and I'll answer it ASAP.")
    end
    render text: response
  end

  private
    def create_response(text)
      Twilio::TwiML::Response.new do |r|
        r.Message text
      end
    end
end
