class Admin::VoteUsersController < ApplicationController
  skip_authorization
  before_action :authorize

  def index
    @vote_users_grid = initialize_grid(User, order: 'firstname')
  end

  def show
    @user = User.find(params[:id])
    @votes = Vote.with_deleted
    @audit_grid = initialize_grid(Audit.where(user_id: @user.id), include: :updater, name: 'g')
    @attend_grid = initialize_grid(Adjustment.where(user_id: @user.id), include: :agenda, name: 'h')
  end

  def attendance_list
    @attend_grid = initialize_grid(User.all_attended)
  end

  def present
    @user = User.find(params[:id])
    @success = VoteService.set_present(@user)
    render
  end

  def not_present
    @user = User.find(params[:id])
    @success = VoteService.set_not_present(@user)
    render
  end

  def all_not_present
    if VoteService.set_all_not_present
      flash[:notice] = t('vote_user.state.all_not_present')
    else
      flash[:alert] = t('vote_user.state.error_all_not_present')
    end
    redirect_to admin_vote_users_path
  end

  def new_votecode
    @user = User.find(params[:id])
    @success = VoteService.set_votecode(@user)
    render
  end

  private

  def authorize
    authorize! :manage_voting, User
  end
end
