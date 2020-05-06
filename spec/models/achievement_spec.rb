require 'rails_helper'
RSpec.describe Achievement, type: :model do
    
    describe 'validations' do
        it 'requires title' do
            achievement = Achievement.new(title: '')
            achievement.valid? 
            #expect(achievement.errors[:title]).to include("can't be blank")
            #expect(achievement.errors[:title]).not_to be_empty
            expect(achievement.valid?).to be_falsy
        end

        it 'requires title to be unique for one user' do
            user = FactoryBot.create(:user)
            first_achievement = FactoryBot.create(:public_achievement, title: 'First Achievement', user: user)
            new_achievement = Achievement.new(title: 'First Achievement', user: user)
            expect(new_achievement.valid?).to be_falsy

        end

        it 'allows different users to have achievements with identical titles' do
            user1 = FactoryBot.create(:user)
            user2 = FactoryBot.create(:user)
            first_achievement = FactoryBot.create(:public_achievement, title: 'First Achievement', user: user1)
            new_achievement = Achievement.new(title: 'First Achievement', user: user2)
            expect(new_achievement.valid?).to be_truthy
        end
    end

    it 'belongs to user' do
        achievement = Achievement.new(title: 'Some title', user: nil)
        expect(achievement.valid?).to be_falsy
    end

    #Testing Associations

    it 'has belons_to user association' do
        #approach 1
        user = FactoryBot.create(:user)
        achievement = FactoryBot.create(:public_achievement, user: user)
        expect(achievement.user).to eq(user)

        #approach 2
        u = Achievement.reflect_on_association(:user)
        expect(u.macro).to eq(:belongs_to)

    end

end