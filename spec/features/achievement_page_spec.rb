require 'rails_helper'

feature 'achievement page' do
    scenario 'achievement public page' do
        achievement = FactoryBot.create(:achievement, title: 'Just did it')
        visit("/achievements/#{achievement.id}")

        expect(page).to have_content('Just did it')

    end

    scenario 'render markdown description' do
        achievement = FactoryBot.create(:achievement, description: 'That *was* hard')
        visit("/achievements/#{achievement.id}")

        #expect(page).to have_content('<em>was</em>')
        #have content ignores any html tag, but we want to check if we have the right
        #styling tag provided by Redcarpet
        expect(page).to have_css('em', text: 'was')  #since redcarpet is rendering html_safe, we need to look for CSS
    end

end