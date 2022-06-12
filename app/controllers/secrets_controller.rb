class SecretsController < ApplicationController
  before_action :set_secret, only: %i[created show destroy]

  def show; end

  def create
    secret = Secret.create!(secret_params)
    redirect_to created_secret_path(secret)
  end

  def created; end

  def destroy
    @secret.destroy
  end

  private

  def secret_params
    params.require(:secret).permit(:content, :iv)
  end

  def set_secret
    @secret = Secret.find(params[:id])
  end
end
