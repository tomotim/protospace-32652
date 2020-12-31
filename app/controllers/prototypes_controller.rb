class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destoroy]
  before_action :login_user_origin?, only: :edit

  def index
    @prototype = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    if Prototype.create(prototype_params)
      redirect_to root_path
    else
      @prototype = Prototype.includes(:user)
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comment.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if Prototype.update(prototype_params)
      redirect_to prototype_path
    else
      render :edit
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def login_user_origin?
    @prototype = Prototype.find(params[:id])
    unless current_user.id == @prototype.user_id 
      redirect_to root_path 
    end
  end
end

#　①＠prototypeの情報がここにくるまでで送られていない。
