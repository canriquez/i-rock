require 'rails_helper'

describe AchievementsController do
  describe 'GET new' do
    it 'renders :new template' do
      get :new # we run action code
      expect(response).to render_template(:new) # we check if the template has been rendered
    end

    it 'assigns new Achievement to @achivement' do
      get :new
      # checks if the assigment :achievement is an object of Achievement class
      expect(assigns(:achievement)).to be_a_new(Achievement) # be a new instance
    end
  end

  describe 'GET show' do
    let(:achievement) { FactoryBot.create(:public_achievement) }

    it 'renders :show template' do
      get :show, params: { id: achievement.id }
      expect(response).to render_template(:show)
    end

    it 'assings requested achievement to @achievement' do
      get :show, params: { id: achievement.id }
      expect(assigns(:achievement)).to eq(achievement)
    end
  end

  describe 'POST create' do
    context "valid data" do
        let(:valid_data) { FactoryBot.attributes_for(:public_achievement) }
        # let!(:achievement) { FactoryBot.build(:public_achievement) }
        # FactoryBot.find_definitions
        it 'redirects to achievement#show' do
        attrs = FactoryBot.attributes_for(:public_achievement)
        puts "here the create hash: "
        p attrs
        # post :create, params: { achievement: FactoryBot.find_definitions(:public_achievement) }
        # post :create, params: { achievement: attrs }
        post :create, params: { achievement: valid_data }

        expect(response).to redirect_to(achievement_path(assigns[:achievement]))
        end

        it 'creates new achievement in database' do
            expect {
                post :create, params: { achievement: valid_data }
            }.to change(Achievement, :count).by(1)
        end
    end

    context "invalid data" do
        let(:invalid_data) {  FactoryBot.attributes_for(:public_achievement, title: '') }
        it "renders :new template" do
            post :create, params: { achievement: invalid_data }
            expect(response).to render_template(:new)
        end
        it "doesn't create new achievement in the database" do
        expect {
            post :create, params: { achievement: invalid_data }
        }.not_to change(Achievement, :count)
        end
    end
  end
end


