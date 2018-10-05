class ClubsController < ApplicationController

  before_action :require_login, except: [:index]

  def index
    @clubs = Club.all
  end

  def show
    @club = Club.find(params[:id])
  end

  def new
    @club = Club.new
  end

  def create
    @club = Club.new(
      name: params[:club][:name],
      description: params[:club][:description],
      user: current_user
    )

    if @club.save
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :new
    end
  end

  def edit
    @club = Club.find(params[:id])
  end

  def update
    @club = Club.find(params[:id])

    if @club && @club.update(name: params[:club][:name], description: params[:club][:description], user: current_user)
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :edit
    end
  end

  private

  def require_login
    if !session[users_id]
      flash[:alert] = ["You need to login first!"]
      redirect_to new_session_path
    end
  end

  def require_ownership
    if current_user != @club.user
      flash[:alert] = ["You are not authorized for that!"]
      redirect_to new_session_path
    end
  end

end
