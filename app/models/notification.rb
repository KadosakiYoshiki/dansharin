class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }

  before_create :set_id

  private

  def set_id
    while self.id.blank? || Notification.find_by(id: self.id).present? do
      self.id = SecureRandom.hex(16)
    end
  end
end
