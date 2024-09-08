class Reaction < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :emoji, presence: true
  validates :user_id, uniqueness: { scope: [:post_id, :emoji], message: "既に同じリアクションを取っています" }

  before_create :set_id
  after_create :create_notification_for_reaction

  EMOJIS = ["👍", "🎉", "❤️", "😂", "😲", "😢"]

  private

  def set_id
    while self.id.blank? || Reaction.find_by(id: self.id).present? do
      self.id = SecureRandom.hex(16)
    end
  end

  def create_notification_for_reaction
    return if post.user_id == self.user_id

    Notification.create(
      user: post.user,
      notifiable: self,
      notification_type: 'reaction'
    )
  end
end
