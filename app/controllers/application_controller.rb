class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include Knock::Authenticable
  before_action :authenticate_user

end
