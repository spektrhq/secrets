class LandingController < ApplicationController
  def index
    @secret = Secret.new
  end

  def faq; end
end
