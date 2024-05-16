class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  validates :name, presence: :true, length: { in: 2..64 }
  validate :acceptable_image

  #after_save :resize_profile_image, if: :profile_image_attached?

  def profile_image_exists?
    profile_image.blob.persisted?
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

    command ? profile_image.variant(command).processed : profile_image
  end

  private

  def acceptable_image
    return unless profile_image.attached?

    unless profile_image.byte_size <= 10.megabyte
      errors.add(:profile_image, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(profile_image.content_type)
      errors.add(:profile_image, "must be a JPEG or PNG")
    end
  end

  def resize_profile_image
    return unless profile_image.attached?

    profile_image.variant(resize: "300x300").processed
  end

  def profile_image_attached?
    self.profile_image.attached?
  end
end
