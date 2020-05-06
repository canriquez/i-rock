class Achievement < ApplicationRecord
  belongs_to :user, optional: true

  validates :title, presence: true
  #validates :uniqueness: { case_sensitive: false }
  validate :unique_title_for_one_user

  enum privacy: %i[public_access private_access friends_access]

  def description_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(description)
    # after creating this metod in the model, we need to adjust the show template
  end

  private 

  def unique_title_for_one_user
    existing_achievement = Achievement.find_by(title: title)
    if existing_achievement && existing_achievement.user == user
      errors.add(:title, "you can't have two achievements with the same title")
    end 
  end 
end
