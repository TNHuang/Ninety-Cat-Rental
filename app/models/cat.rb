class Cat < ActiveRecord::Base
  COLORS = %w{black white calico tabby grey}

  validates :user_id, :birth_date, :sex, :color, :name, presence: true
  validates_inclusion_of :color, in: COLORS
  validates_inclusion_of :sex, in: ["M", "F"]
  validate :birthday_on_or_before_today

  has_many :cat_rental_requests,
    class_name: "CatRentalRequest",
    foreign_key: :cat_id,
    primary_key: :id,
    dependent: :destroy

  belongs_to :owner,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id


  def age
    Date.today.year - self.birth_date.year
  end

  private
  def birthday_on_or_before_today
    if !birth_date.nil? && birth_date > Date.today
      errors[:birth_date] << "can't be later than today"
    end
  end
end