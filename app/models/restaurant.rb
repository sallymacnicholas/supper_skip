class Restaurant < ActiveRecord::Base
  # attr_accessor :slug
  before_save :set_slug
  belongs_to :user
  
  validates :name, presence: true,
                   uniqueness: true
  validates :slug, uniqueness: true
  validates :description, presence: true
  
  def set_slug
  #   binding.pry
    if slug.nil? || slug == ""
      self.slug = name.parameterize
    else
      self.slug = slug.parameterize
    end
  end

  def to_param
    slug
  end
end
