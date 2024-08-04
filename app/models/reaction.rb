class Reaction < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :emoji, presence: true
  validates :user_id, uniqueness: { scope: [:post_id, :emoji], message: "has already reacted with this emoji" }

  before_create :set_id

  EMOJIS = ["👍", "🎉", "❤️", "😂", "😲", "😢"]

  private

  def set_id
    while self.id.blank? || Reaction.find_by(id: self.id).present? do
      self.id = SecureRandom.hex(16)
    end
  end
end
