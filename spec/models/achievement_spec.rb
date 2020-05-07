require 'rails_helper'
RSpec.describe Achievement, type: :model do
    
    describe 'validations' do
=begin         
            it 'requires title' do
            achievement = Achievement.new(title: '')
            achievement.valid? 
            #expect(achievement.errors[:title]).to include("can't be blank")
            #expect(achievement.errors[:title]).not_to be_empty
            expect(achievement.valid?).to be_falsy
        end 
=end

        it { should validate_presence_of(:title) }
=begin   We eliminate this by  passing a scope and message block to the uniqueness validation in model and using shoulda/matchers below
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
=end
        it { should validate_uniqueness_of(:title).scoped_to(:user_id).with_message("you can't have two achievements with the same title")}
    end

=begin 
    it 'belongs to user' do
        achievement = Achievement.new(title: 'Some title', user: nil)
        expect(achievement.valid?).to be_falsy
    end
=end   #below shoulda/matchers simplifies the presence test for :user and simplifying the code above to one line!

        it { should validate_presence_of(:user)}

    #Testing Associations

=begin     
        it 'has belons_to user association' do
        #approach 1
        user = FactoryBot.create(:user)
        achievement = FactoryBot.create(:public_achievement, user: user)
        expect(achievement.user).to eq(user)

        #approach 2
        u = Achievement.reflect_on_association(:user)
        expect(u.macro).to eq(:belongs_to)
    end 
=end # we eliminate this group code above by using shoulda/matchers below

    it { should belong_to (:user) }


    it 'converts markdown to html' do
        achievement = Achievement.new(description: 'Awesome **thing** I *actually* did')
        expect(achievement.description_html).to include('<em>actually</em>')
    end

    it 'has silli title' do
        achievement = Achievement.new(title: "New Achievement", user: FactoryBot.create(:user, email: 'test@test.com'))
        expect(achievement.silly_title).to eq('New Achievement by test@test.com')
    end

    it 'only fetches achievments which title starts from provided letter' do
        user = FactoryBot.create(:user, email: 'another4@email.com')
        achievement1 = FactoryBot.create(:public_achievement, title: 'Read a book', user: user)
        achievement2 = FactoryBot.create(:public_achievement, title: 'Passed an exam', user: user)
        expect(Achievement.by_letter("R")).to eq([achievement1])
    end

    #Testing queries
    it 'sorts achievements by user emails' do
        albert = FactoryBot.create(:user, email: 'albert@email.com')
        rob = FactoryBot.create(:user, email: 'rob@email.com')
        achievement1 = FactoryBot.create(:public_achievement, title: 'Red a book', user: rob)
        achievement2 = FactoryBot.create(:public_achievement, title: 'Rocked it', user: albert)
        expect(Achievement.by_letter("R")).to eq([achievement2, achievement1])

    end

end