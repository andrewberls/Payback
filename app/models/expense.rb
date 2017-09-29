require 'expression_parser'

class Expense < ActiveRecord::Base

  attr_accessible :title, :amount, :action, :active

  belongs_to :group

  belongs_to :creditor, class_name: "User"
  belongs_to :debtor,   class_name: "User"

  has_and_belongs_to_many :notifications

  has_and_belongs_to_many :tags

  has_and_belongs_to_many :payments

  validates :amount,
    presence: true,
    numericality: { greater_than_or_equal_to: 0.01 }

  validates :title, presence: true, length: { maximum: 75 }

  PAYBACK_COPY = 'Pay me back full amount'.freeze
  SPLIT_COPY = 'Split cost, including me'.freeze

  def self.build(params)
    exp_params = params[:expense]
    Expense.new(exp_params) do |exp|
      exp.action = (params[:commit] == PAYBACK_COPY) ? :payback : :split
      exp.amount = ExpressionParser.parse(exp_params[:amount])

      tags = params[:tag_list].split(',')
      if tags.present?
        tags.each { |name| exp.tags << Tag.find_or_create_by_title(name) }
      end
    end
  end

  def edited?
    created_at != updated_at
  end

  def inactive?
    !active?
  end

  def deactivate
    update_attributes active: false
  end

  # The cost for each user, calculated based on the action type
  # Split includes current user, Payback excludes
  def cost_for(users)
    user_count    = (action == :split) ? users.count + 1 : users.count
    cost_per_user = amount / user_count
    cost_per_user = "%.2f" % ((cost_per_user*2.0).round / 2.0).to_f # Round to nearest $0.50

    cost_per_user.to_f
  end

  # Split and assign a debt amongst a set of selected users
  # Creates a duplicated instance to assign to each user
  def assign_to(*users)
    users.flatten.each do |user|
      expense      = self.dup
      expense.tags = self.tags.dup
      user.add_debt(expense)
    end
  end

  def has_tag?(title)
    tags.any? { |t| t.title == title }
  end

  def to_s
    active_str = active? ? 'active' : 'inactive'
    "#<Expense id: #{id}, $#{amount} from #{creditor.first_name}
      to #{debtor.first_name} (#{active_str})>".squish
  end

  def inspect
    to_s
  end

end
