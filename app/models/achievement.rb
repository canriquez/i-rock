class Achievement < ApplicationRecord
  #belongs_to :user, optional: true || This is disabled as the option: 
                                  # || true is actually breaking the association and 
                                  # || shoulda/matchers fails to test associations
  
  belongs_to :user

  validates :title, presence: true
  validates :user, presence: true  #this validation will breake controller tests as there we create Achievements with no users
  #validates :uniqueness: { case_sensitive: false } this was changed by the method unique_title_for_one_user
  #validate :unique_title_for_one_user

  #next step, we validate using scope instade of a new method. So we disable the method and use this below instead

  validates :title, uniqueness: {
    scope: :user_id,
    message: "you can't have two achievements with the same title"
  }

  enum privacy: %i[public_access private_access friends_access]

  def description_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(description)
    # after creating this metod in the model, we need to adjust the show template
  end

  def silly_title
    #self.title + " by " + self.user.email
    "#{title} by #{user.email}"
  end

  def self.by_letter(letter)
    #where("title LIKE ?", "#{letter}%")
    #for the second test 'sorts achievements...' we use the code blow
    includes(:user).where("title LIKE ?", "#{letter}%").order("users.email")
  end



  private 

  def unique_title_for_one_user
    existing_achievement = Achievement.find_by(title: title)
    if existing_achievement && existing_achievement.user == user
      errors.add(:title, "you can't have two achievements with the same title")
    end 
  end 




end
