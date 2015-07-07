class Restaurant < ActiveRecord::Base
  before_save :set_slug
  belongs_to :user

  def set_slug
    if slug.nil? || slug == ""
      self.slug = name
    end
  end
end
