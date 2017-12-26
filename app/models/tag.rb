# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Tag < ActiveRecord::Base
  attr_accessible :title

  has_and_belongs_to_many :expenses

  CORE_TYPES = %w(
    Food
    Rent
    Household
  )

  def to_s
    "#<Tag id: #{id}, title: #{title}>"
  end

  def inspect
    to_s
  end
end
