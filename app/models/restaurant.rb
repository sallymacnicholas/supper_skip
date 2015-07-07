class Restaurant < ActiveRecord::Base
  before_validation :set_slug
  belongs_to :user

  def set_slug
    if slug.nil? || slug == ""
      self.slug = name.parameterize
    else
      self.slug = slug.parameterize
    end
  end
end
