# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development? && AdminUser.count == 0
AdminUser.create!(email: 'admin@uvoaistaging.com', password: 'password', password_confirmation: 'password') if Rails.env.staging? && AdminUser.count == 0
AdminUser.create!(email: 'admin@uvoaiprod.com', password: 'password', password_confirmation: 'password') if Rails.env.production? && AdminUser.count == 0

prompts_list = [
  {
    display_text: "Experiencing Symptoms?",
    question_text: "I am experiencing some symptoms can you help me identify the issue?",
    order: 1
  },
  {
    display_text: "Need help with lab results?",
    question_text: "I've got my lab results can you help me get the details?",
    order: 2
  },
  {
    display_text: "Have a health question?",
    question_text: "I need opinion on some health issues.",
    order: 3
  }
]
if Prompt.count == 0
  prompts_list.each { |prompt| Prompt.create(prompt) }
end

if Setting.count == 0
  Setting.create(name: "chats_welcome_message", value: WELCOME_MESSAGE)
  Setting.create(name: "chats_agreement_message", value: AGREEMENT_MESSAGE)
  Setting.create(name: "public_access", value: "true")
end
