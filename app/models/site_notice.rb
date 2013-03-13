require 'tokenable'

class SiteNotice < ActiveRecord::Base
  include Tokenable

  LIFESPAN = 4.days

  attr_accessible :title, :expires_at

  before_create :set_expires_at

  def close_key
    "closed-#{id}".to_sym
  end

end
