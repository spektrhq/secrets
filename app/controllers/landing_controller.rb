class LandingController < ApplicationController
  def index
    @secret = Secret.new
  end
end
