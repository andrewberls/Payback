# == Schema Information
#
# Table name: site_notices
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  expires_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
