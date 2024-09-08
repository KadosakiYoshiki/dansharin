class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :post_images
  belongs_to :replied, class_name: 'Post', optional: true
  has_many :replies, class_name: 'Post', foreign_key: 'replied_id'
  has_many :reactions, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :content, presence: true
  validates :post_images, limit: { min: 0, max: 1 }
  #validate :acceptable_image

  before_create :set_id
  after_create :create_notification_for_reply
  #after_save :resize_post_images, if: :post_images_attached?

  def post_images_exists?
    post_images.blob.persisted?
  end

  def image_url(version = :origin)
    command = case version
              when :thumb
                { resize_to_limit: [320, 240] }
              when :lg
                { resize_to_limit: [1024, 768] }
              when :ogp
                { resize_to_limit: [120, 630] }
              else
                false
              end

    command ? post_images.variant(command).processed : post_images
  end

  def reaction_count(emoji)
    reactions.where(emoji: emoji).count
  end

  def replies_count
    replies.count
  end

  private

  def acceptable_image
    return unless post_images.attached?

    if post_images.map(&:byte_size).any? { |image_size| image_size > 10.megabyte }
      errors.add(:post_images, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(post_images.map(&:content_type))
      errors.add(:post_images, "must be a JPEG or PNG")
    end
  end

  def resize_post_images
    return unless post_images.attached?

    post_images.variant(resize: "300x300").processed
  end

  def post_images_attached?
    self.post_images.attached?
  end

  def set_id
    while self.id.blank? || Post.find_by(id: self.id).present? do
      self.id = SecureRandom.hex(16)
    end
  end

  def create_notification_for_reply
    return unless replied_id.present? && replied.user_id != self.user_id

    Notification.create(
      user: replied.user,
      notifiable: self,
      notification_type: 'reply'
    )
  end
end
