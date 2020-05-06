require 'rails_helper'
describe AchievementsController do

  shared_examples "public access to achievements" do

    describe "GET index" do
      it "renders :index template" do
          get :index
          expect(response).to render_template(:index)
      end

      it "assigns only public achievements to template" do
          public_achievement = FactoryBot.create(:public_achievement)
         # private_achivement = FactoryBot.create(:private_achievement)
          get :index
          expect(assigns(:achievements)).to match_array([public_achievement])
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

  end

  describe "guest user" do

    it_behaves_like "public access to achievements"

    #We test that any guest is sent to login page on #new #create #edit #Update #destroy 
    describe "GET new" do
      it "redirects to login page" do
        get :new
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "POST create" do
      let(:valid_data) { FactoryBot.attributes_for(:public_achievement) }
      it "redirects to login page" do
        post :create, params: { achievement: valid_data }
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "GET edit" do
      let(:achievement) { FactoryBot.create(:public_achievement) }
      it "redirects to login page" do
         get :edit, params: { id: achievement.id }
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "PUT update" do
      let(:valid_data) { FactoryBot.attributes_for(:public_achievement, title: "New Title") }
      let(:achievement) { FactoryBot.create(:public_achievement) }
      it "redirect to login page" do
        put :update, params: { id: achievement, achievement: valid_data }
        expect(response).to redirect_to(new_user_session_url)
      end
    end

    describe "DELETE destroy" do
      let(:achievement) { FactoryBot.create(:public_achievement) }
      it "redirects to login page" do
          delete :destroy, params: { id: achievement.id }
          expect(response).to redirect_to(new_user_session_url)
      end
    end
    
  end
  
    describe "authenticated user" do
      let(:user) { FactoryBot.create(:user) }
      before do
        sign_in(user)
      end

    it_behaves_like "public access to achievements"
    
    describe "GET index" do
      it "renders :index template" do
          get :index
          expect(response).to render_template(:index)
      end

      it "assigns only public achievements to template" do
          public_achievement = FactoryBot.create(:public_achievement)
          private_achivement = FactoryBot.create(:private_achievement)
          get :index
          expect(assigns(:achievements)).to match_array([public_achievement])
      end
    end

    describe 'GET show' do
      let(:achievement) { FactoryBot.create(:public_achievement) }
  
      it 'renders :show template' do
        get :show, params: { id: achievement }
        expect(response).to render_template(:show)
      end
  
      it 'assings requested achievement to @achievement' do
        get :show, params: { id: achievement }
        expect(assigns(:achievement)).to eq(achievement)
      end
    end

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
  
    describe 'POST create' do
      context 'valid data' do
        let(:valid_data) { FactoryBot.attributes_for(:public_achievement) }
        # let!(:achievement) { FactoryBot.build(:public_achievement) }
        # FactoryBot.find_definitions
        it 'redirects to achievement#show' do
          attrs = FactoryBot.attributes_for(:public_achievement)
          puts 'here the create hash: '
          p attrs
          # post :create, params: { achievement: FactoryBot.find_definitions(:public_achievement) }
          # post :create, params: { achievement: attrs }
          post :create, params: { achievement: valid_data }
  
          expect(response).to redirect_to(achievement_path(assigns[:achievement]))
        end
  
        it 'creates new achievement in database' do
          expect do
            post :create, params: { achievement: valid_data }
          end.to change(Achievement, :count).by(1)
        end
      end
  
      context 'invalid data' do
        let(:invalid_data) { FactoryBot.attributes_for(:public_achievement, title: '') }
        it 'renders :new template' do
          post :create, params: { achievement: invalid_data }
          expect(response).to render_template(:new)
        end
        it "doesn't create new achievement in the database" do
          expect do
            post :create, params: { achievement: invalid_data }
          end.not_to change(Achievement, :count)
        end
      end
    end

    context "is not the owner of the achievement" do 
      #to test we create an achievement with no user (belongs_to :user optional: true) and try to edit, update and destroy with signed in user
      describe "GET edit" do
        it "redirects to achievements page" do
           get :edit, params: { id: FactoryBot.create(:public_achievement) }
          expect(response).to redirect_to(achievements_path)
        end
      end
  
      describe "PUT update" do
        let(:valid_data) { FactoryBot.attributes_for(:public_achievement, title: "New Title") }
        let(:achievement) { FactoryBot.create(:public_achievement) }
        it "redirect to achievements page" do
          put :update, params: { id: achievement, achievement: valid_data }
          expect(response).to redirect_to(achievements_path)
        end
      end
  
      describe "DELETE destroy" do
        let(:achievement) { FactoryBot.create(:public_achievement) }
        it "redirects to achievements page" do
            delete :destroy, params: { id: achievement }
            expect(response).to redirect_to(achievements_path)
        end
      end
    end

    context "is the owner of the achievement" do
      let(:achievement) { FactoryBot.create(:public_achievement, user: user) }

      describe "GET edit" do
          it "renders :edit template" do
            get :edit, params: { id: achievement.id }
            expect(response).to render_template(:edit)
          end
          it "addigns the requested achievement to template" do
            get :edit, params: { id: achievement.id }
            expect(assigns(:achievement)).to eq(achievement)
          end
      end
      describe "PUT update" do    
          context "valid data" do
            let(:valid_data) { FactoryBot.attributes_for(:public_achievement, title: "New Title", user: user) }
              it "redirect to achievements#show" do
                put :update, params: { id: achievement, achievement: valid_data }
                expect(response).to redirect_to(achievement)
              end
              it "updates achievement in the database" do
                put :update, params: { id: achievement, achievement: valid_data }
                achievement.reload  #here we resinc the instance variable object with the last DB update
                expect(achievement.title).to eq("New Title")    
              end
          end 
    
          context "invalid data" do
            let(:invalid_data) { FactoryBot.attributes_for(:public_achievement, title: '', description: 'new', user: user) }
              
            it "renders :edit template" do
                put :update, params: { id: achievement, achievement: invalid_data }
                expect(response).to render_template(:edit) 
            end
            it "doesn't update achievement in the database" do
                put :update, params: { id: achievement, achievement: invalid_data }
                achievement.reload
                expect(achievement.description).not_to eq('new')
            end
          end
      end
    
      describe "DELETE destroy" do
        it "redirects to achievements#index" do
            delete :destroy, params: { id: achievement.id }
            expect(response).to redirect_to(achievement_path)
        end
    
        it "deletes achievement from database" do
            delete :destroy, params: { id: achievement.id }
            expect(Achievement.exists?(achievement.id)).to be_falsy
        end
    
      end
          
    end

  end
end
