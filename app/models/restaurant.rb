class Restaurant < ActiveRecord::Base
  before_save :set_slug
  belongs_to  :user
  
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
end
