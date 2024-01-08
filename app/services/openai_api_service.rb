class OpenaiApiService
  class << self
    def create_chat
      thread = AI_CLIENT.threads.create().transform_keys(&:to_sym)

      thread[:id]
    end

    def create_message(thread_id, message)
      AI_CLIENT.messages.create(
        thread_id: thread_id,
        parameters: {
          role: "user",
          content: message
        }
      )
    end

    def run_chat(thread_id, public_assistant)
      run = AI_CLIENT.runs.create(
        thread_id: thread_id,
        parameters: {assistant_id: public_assistant ? ENV.fetch("PUBLIC_ASSISTANT_ID") : ENV.fetch("MEDICAL_ASSISTANT_ID")}
      ).transform_keys(&:to_sym)
      run[:id]
    end

    def delete_chat(thread_id)
      AI_CLIENT.threads.delete(id: thread_id)
    end
  end
end
