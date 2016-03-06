require 'rails_helper'

RSpec.describe GamesController, type: :controller do
	describe "games#destroy action" do
		it "should allow a user successfully remove from database" do
		end
		it "should deny an invalid user removing game" do
		end
	end
	describe "games#show action" do
		it "should successfully render game page" do
			game = FactoryGirl.create(:game)
			user = FactoryGirl.create(:user)
			sign_in user

			get :show, id: game.id

			expect(response).to render_template :show
		end
	end

	describe "games#create action" do
		it "should successfully create a new game" do
			user = FactoryGirl.create(:user)
			sign_in user

			post :create, game: { name: 'Rival' }
			expect(response).to redirect_to( game_path(assigns(:game).id))

			game = Game.last
			expect(game.name).to eq('Rival')
		end
		it "should properly deal with validation error" do
			user = FactoryGirl.create(:user)
			sign_in user

			post :create, game: { name: ''}
			expect(response).to have_http_status(:unprocessable_entity)
			expect(Game.count).to eq 0
		end
	end

	describe "games#new action" do
		it "should successfully render new page" do
			user = FactoryGirl.create(:user)
			sign_in user

			get :new
			expect(response).to render_template("new")
		end
		it "should require a user to be signed in" do
			get :new
			expect(response).to redirect_to new_user_session_path
		end
	end

	describe "games#index action" do
		it "should successfully render index page" do
			get :index
			expect(response).to render_template :index
		end
	end
end
