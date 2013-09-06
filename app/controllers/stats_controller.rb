class StatsController < ApplicationController

  before_filter :must_be_logged_in
  before_filter :set_group

  def stats
    return redirect_to new_group_path if current_user.groups.blank?

    if request.xhr?
      render partial: 'group', locals: { group: @group }
    else
      render
    end
  end

  # Total amount loaned vs borrowed
  def type_proportions
    debt_amt   = current_user.total_debt_amt(@group)
    credit_amt = current_user.total_credit_amt(@group)
    return render json: {
      stats: [
        { type: 'debt', amt: debt_amt },
        { type: 'credit', amt: credit_amt }
      ]
    }
  end

  def segments
    peers = @group.peers(current_user)

    if params[:type] == 'debts'
      # How much you've borrowed over time
      segments = peers.map do |user|
        { name: user.full_name, amt: current_user.total_debt_amt_to(user) }
      end
    else
      # How much you've loaned over time
      segments = peers.map do |user|
        { name: user.full_name, amt: current_user.total_credit_amt_to(user) }
      end
    end

    return render json: { stats: segments }
  end

  private

  def set_group
    @group = Group.find_by_gid(params[:gid])
  end
end
