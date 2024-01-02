class CustomFailure < Devise::FailureApp
  def respond
    self.status = 401
    self.content_type = 'json'
    self.response_body = { error: "Invalid User Session"}.to_json
  end
end
