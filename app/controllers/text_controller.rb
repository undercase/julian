require 'twilio-ruby'

class TextController < TwilioController
  skip_before_action :verify_authenticity_token
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
        response = create_response("Please wait patiently for the answer to your question! We're working on it right now.")
      else
        if params[:Body][-1] == "?"
          asker.question = params[:Body]
          asker.ready = true
          response = create_response("We've received your question, \"#{params[:Body]}\". My team is working on answering it as I type this.")
          asker.save
        else
          response = create_response("If you're asking a question, make sure it ends with '?'!")
        end
      end
    elsif params[:From]
      Asker.create(number: params[:From].to_s)
      response = create_response("Hi! I'm your friendly homework question explanation service. Just text me a question with a '?' at the end, and my crack team of tutors will answer it as fast as possible.")
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
