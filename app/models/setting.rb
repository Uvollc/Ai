class Setting < ApplicationRecord
  validates :name, :value, presence: true
  validate :valid_public_access_value?

  private

  def valid_public_access_value?
    return unless name == "public_access"

    errors.add(:value, "can either be 'true' or 'false'.") unless value.in? ["true", "false"]
  end
end
