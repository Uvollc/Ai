class Chat < ApplicationRecord
  belongs_to :chatable, polymorphic: true

  before_create -> (chat) { chat.thread_id = OpenaiApiService.create_chat}

  MESSAGE_LIMIT = 3

  def welcome_message
    "Hello, what is your health related question? Tell me your symptoms or ask me general health questions like a lab result or what does diastolic pressure mean."
  end

  def reached_message_limit?
    self.message_count == MESSAGE_LIMIT
  end

  def increment_message_count
    self.update(message_count: self.message_count+1)
  end
end
