class UsersController < ApplicationController
  # before_action :user_name_downcase, except: [:index]
  before_action :authenticate_user!, only: [:edit,:update,:ban,:free]
  load_resource find_by: :name

  def index
    @site_stat = Stat.singleton
    @users = @users.last(48);
  end

  def show
    @replies = @user.replies.desc.includes(:topic).last(20)
    @topics = @user.topics.desc.includes(:node).last(20)
  end

  def edit
  end

  def update
    @user.update_attributes(update_params)
    redirect_to edit_user_path, alert: @user.errors.full_messages
  end

  def replies
    @replies = @user.replies.desc.includes(:topic).page(params_page)
  end

  def topics
    @topics = @user.topics.desc.includes(:node).page(params_page)
  end

  def favorites
    @favorites = @user.favorites.desc.page(params_page)
    @topics = Topic.where(id:@favorites.pluck(:topic_id)).desc.includes(:node)
  end

  def calendar
    render :json => @user.calendar_data
  end

  def ban
    authorize! :manage, @user
    @user.ban!
    redirect_to @user
  end

  def free
    authorize! :manage, @user
    @user.free!
    redirect_to @user
  end

  protected
  # def user_name_downcase
  #    # 处理有大写字母的情况
  #   if params_id != params_id.downcase
  #     redirect_to request.path.downcase, status: 301
  #   end
  # end

  def update_params
    params.require(:user).permit(:avatar,:city,:company,:twitter_account,:personal_website,:signature,:introduction)
  end

end
