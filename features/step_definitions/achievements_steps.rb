Given("I am a guest user") do
  end
  
  Given("there is apublic achievement") do
    @achievement = FactoryBot.create(:public_achievement, title: 'I did it')
  end
  
  When("I go to the achievement's page") do
    visit(achievement_path(@achievement.id))
  end
  
  Then("I must achievement's content") do
   expect(page).to have_content('I did it')
  end