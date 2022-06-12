class ApplicationController < ActionController::Base
  helper_method :default_meta_tags

  private

  def default_meta_tags
    share = {
      title: 'Securely sharing secrets never been this easy!', image: helpers.image_url('screenshot.png')
    }
    {
      title: 'Securely sharing secrets never been this easy! | Spektr Secrets',
      twitter: share,
      og: share
    }
  end
end
