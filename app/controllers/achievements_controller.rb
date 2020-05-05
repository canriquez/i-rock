class AchievementsController < ApplicationController
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

  def show
    @achievement = Achievement.find(params[:id])
    # the row below was refactored using red green refactor. With rspect gree, it was move to the model as a method.
    # @description = Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(@achievement.description)
  end

  private

  def achievement_params
    params.require(:achievement).permit(:title, :description, :privacy, :cover_image, :features)
  end
end
