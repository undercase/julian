class TwilioController < ApplicationController
  before_filter :twilio_header

  def render *args
    args[-1][:text] = args[-1][:text].text if args[-1][:text]
    super(*args)
  end

  protected
    def twilio_header
      response.headers["Content-Type"] = "text/xml"
    end
end
