class Achievement < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  enum privacy: %i[public_access private_access friends_access]

  def description_html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(description)
    # after creating this metod in the model, we need to adjust the show template
  end
end
