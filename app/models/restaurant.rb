class Restaurant < ActiveRecord::Base
  before_save :set_slug
  belongs_to :user
  has_many :categories
  has_many :items
  has_many :orders

  validates :name, presence: true,
                   uniqueness: true
  validates :slug, uniqueness: true
  validates :description, presence: true

  def set_slug
    if slug.nil? || slug == ""
      self.slug = name.parameterize
    else
      self.slug = slug.parameterize
    end
  end

  def to_param
    slug
  end

  def self.featured_restaurants
    all.sample(3)
  end
end
