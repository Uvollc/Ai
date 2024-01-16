class CustomFailure < Devise::FailureApp
  def respond
    self.status = 401
    self.response_body = "User does not exist"
  end
end
