# A way to manage site-wide notifications without constantly
# modifying source.

class SiteNotice < ActiveRecord::Base

  attr_accessible :title, :expires_at

  before_create :set_expires_at

  def set_expires_at
    self[:expires_at] ||= 4.days.from_now
  end

  def close_key
    :"closed-#{id}"
  end

end
