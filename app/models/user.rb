class User < ActiveRecord::Base

  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  validates :user_name, presence: true, uniqueness: true

  after_initialize :ensure_session_token #maybe before_validation ? if this fail

  has_many :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id

  has_many :cat_rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :user_id,
    primary_key: :id

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.find_by_credentials(user_name, unencrypted_password)
    current_user = User.find_by_user_name(user_name)
    return nil if current_user.nil?
    if current_user.is_password?(unencrypted_password)
      return current_user
    else
      nil
    end
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def password=(unencrypted_password)
    if unencrypted_password.present?
      self.password_digest = BCrypt::Password.create(unencrypted_password)
    end
  end

  def is_password?(unencrypted_password)
    BCrypt::Password.new(self.password_digest).is_password?(unencrypted_password)
  end



  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end