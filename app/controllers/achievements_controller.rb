class AchievementsController < ApplicationController
before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy]
before_action :owners_only, only: [ :edit, :update, :destroy]

  def index
    @achievements = Achievement.public_access
  end

  def new
    @achievement = Achievement.new
  end

  def create
    @achievement = Achievement.new(achievement_params)
    if @achievement.save
      redirect_to achievement_url(@achievement), notice: 'Achievement has been created'
    else
      render :new
    end
  end

  def edit
    #@achievement = Achievement.find(params[:id]) THIS WAS REPLOACED BY OWNERS ONLY before_action method
  end

  def update
    #@achievement = Achievement.find(params[:id]) THIS WAS REPLOACED BY OWNERS ONLY before_action method


    #redirect_to achievement_path(@achievement)
    #render nothing: true  /this here was used to trick rspect as 
    #we dont render with update -- We dont need this at all
    #------------------
    #after refactoring:
    if @achievement.update_attributes(achievement_params)  #if we succeed to update
        redirect_to achievement_path(params[:id])  #then we show the update done
    else 
        puts "Update is invalid - Render..."
        render :edit
    end
  end

  def destroy
    #Achievement.destroy(params[:id])
    @achievement.destroy  #this has already the right id created in the members_only method
    redirect_to achievement_path  
  end


  def show
    @achievement = Achievement.find(params[:id])

    # the row below was refactored using red green refactor. With rspect gree, it was move to the model as a method.
    # @description = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(@achievement.description)
  end


  private

  def achievement_params
    params.require(:achievement).permit(:title, :description, :privacy, :cover_image, :features)
  end

  def owners_only
    @achievement = Achievement.find(params[:id])
    if current_user != @achievement.user 
      redirect_to achievements_path
    end 
  end 

end
