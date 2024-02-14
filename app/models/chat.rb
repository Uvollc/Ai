class Chat < ApplicationRecord
  belongs_to :chatable, polymorphic: true

  before_create -> (chat) { chat.thread_id = OpenaiApiService.create_chat }
  after_destroy -> (chat) { OpenaiApiService.delete_chat(chat.thread_id) }

  MESSAGE_LIMIT = 4

  def welcome_message
    return Setting.find_by(name: "agreement_message").value if public_assistant

    Setting.find_by(name: "welcome_message").value
  end

  def reached_message_limit?
    self.message_count >= MESSAGE_LIMIT
  end

  def make_messaging_updates(message)
    OpenaiApiService.create_message(self.thread_id, message)
    run_id = OpenaiApiService.run_chat(self.thread_id, self.public_assistant)
    self.title = message[0..50] if message_count == 0
    self.title = message[0..50] if (message_count == 1 && public_assistant)
    self.message_count += 1
    self.save

    run_id
  end
end
