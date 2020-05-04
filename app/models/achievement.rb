class Achievement < ApplicationRecord
    validates :title, presence: true
    enum privacy: [ :public_access, :private_access, :friends_access ]
end
