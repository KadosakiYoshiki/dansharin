class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image

  has_many :posts, dependent: :destroy
  has_many :reactions, dependent: :destroy

  validates :name, presence: true, length: { in: 2..64 }
  validates :username, presence: true, length: { maximum: 16 }, uniqueness: { case_sensitive: false }, format: { with: /\w/, message: 'に使用できるのは、英数字とアンダーバーのみです。' }, on: :update
  validates :description, length: { maximum: 140 }
  validate :acceptable_image

  before_create :set_id_username
  #after_save :resize_profile_image, if: :profile_image_attached?

  def to_param
    username ? username : super()
  end

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

  def set_id_username
    while self.id.blank? || User.find_by(id: self.id).present? do
      self.id = SecureRandom.hex(16)
    end
    while self.username.blank? || User.find_by(username: self.username).present? do
      self.username = SecureRandom.alphanumeric
    end
  end
end
