class CustomFailure < Devise::FailureApp
  def respond
    self.status = 401
    self.response_body = "Invalid User Session"
  end
end
