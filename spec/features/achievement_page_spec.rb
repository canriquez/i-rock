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
        expect(page).to have_css('em', text: 'was')  #since redcarpet is rendering html_safe, we need to look for CSS
    end

end