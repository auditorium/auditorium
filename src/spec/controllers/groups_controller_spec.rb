require 'spec_helper'

describe GroupsController do

  describe 'guest user access' do
    describe 'GET #index' do
      it 'redirects to the login page' do
        get :index
        expect(response).to redirect_to new_user_session_path(locale: nil)
      end
    end

    describe 'GET #show' do
      it 'redirects to the login page' do
        group = create(:topic_group)     
        get :show, id: group
        expect(response).to redirect_to new_user_session_path(locale: nil)
      end
    end

    describe 'GET #new' do
      it 'redirects to the login page' do
        get :new
        expect(response).to redirect_to new_user_session_path(locale: nil)
      end
    end

    describe 'GET #edit' do
      it 'redirects to the login page' do
        group = create(:learning_group)
        get :edit, id: group
        expect(response).to redirect_to new_user_session_path(locale: nil)
      end
    end

    describe 'POST #create' do
      it 'redirects to the login page' do
        post :create, group: attributes_for(:topic_group)
        expect(response).to redirect_to new_user_session_path(locale: nil)
      end
    end

    describe 'PUT #update' do
      it 'redirects to the login page' do 
        @group = create(:topic_group, title: 'Topic Group')
        put :update, id: @group, group: attributes_for(:topic_group)
        expect(response).to redirect_to new_user_session_path(locale: nil)
      end

    end

    describe 'DELETE #destroy' do
      it 'redirects to the login page' do
        @group = create(:topic_group)
        delete :destroy, id: @group
        expect(response).to redirect_to new_user_session_path(locale: nil)
      end
    end
  end

  shared_examples('member access to groups') do
    describe 'GET #index' do
      it 'populates an array of groups' do
        group = create(:topic_group)
        get :index
        expect(assigns(:groups)).to match_array [group]
      end

      it 'renders the index view' do
        get :index
        expect(response).to render_template :index
      end
    end

    describe 'GET #show' do
      it 'assigns the requested group to @group' do
        group = create(:topic_group)
        get :show, id: group
        expect(assigns(:group)).to eq group
      end
      
      it 'renders the :show template' do
        group = create(:topic_group)     
        get :show, id: group
        expect(response).to render_template :show
      end
    end
  end

  describe 'logged in as member' do
    before(:each) { login create(:user) }

    it_behaves_like "member access to groups"

    describe 'GET #new' do
      it 'denies access' do
        get :new
        expect(response).to redirect_to home_url
      end
    end

    describe 'GET #edit' do
      it 'denies access' do
        group = create(:learning_group)
        get :edit, id: group
        expect(response).to redirect_to home_url
      end
    end

    describe 'POST #create' do
      it 'denies access' do
        post :create, group: attributes_for(:topic_group)
        expect(response).to redirect_to home_url
      end
    end

    describe 'PUT #update' do
      it 'denies access' do 
        @group = create(:topic_group, title: 'Topic Group')
        put :update, id: @group, group: attributes_for(:topic_group)
        expect(response).to redirect_to home_url
      end

    end

    describe 'DELETE #destroy' do

      it 'denies access' do
        @group = create(:topic_group)
        delete :destroy, id: @group
        expect(response).to redirect_to home_path
      end
    end
  end

  describe 'logged in as admin' do
    before(:each) { login create(:admin) }

    it_behaves_like "member access to groups"

    describe 'GET #new' do
      it 'assigns a new Group to @group' do
        get :new
        expect(assigns(:group)).to be_a_new(Group)
      end

      it 'renders the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested group to @group' do
        group = create(:learning_group)
        get :edit, id: group
        expect(assigns(:group)).to eq group
      end 

      it 'renders the :edit template' do
        group = create(:learning_group)
        get :edit, id: group
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new group in the database' do
          expect {
            post :create, group: attributes_for(:topic_group)
          }.to change(Group, :count).by(1)
        end

        it 'redirects to the group page' do
          post :create, group: attributes_for(:topic_group)

          expect(response).to redirect_to group_path(assigns(:group))
        end
      end

      context 'with invalid attributes' do
        it 'does not save the new group in the database' do
          expect {
            post :create, group: attributes_for(:invalid_group)
          }.to_not change(Group, :count)
        end
        it 're-redirects to the :new template' do
          post :create, group: attributes_for(:invalid_group)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PUT #update' do
      before(:each) do
        @group = create(:topic_group, title: 'Topic Group')
      end

      it "locates the requested @group" do
        put :update, id: @group, group: attributes_for(:topic_group)
        expect(assigns(:group)).to eq(@group)
      end

      context 'with valid attributes' do
        it 'updates the group in the database' do
          put :update, id: @group, group: attributes_for(:topic_group, title: 'This is a topic group')
          @group.reload
          expect(@group.title).to eq('This is a topic group')
        end

        it 'redirects to the group' do 
          put :update, id: @group, group: attributes_for(:topic_group)
          expect(response).to redirect_to @group
        end
      end

      context 'with invalid attributes' do
        it "does not change the group's title" do
          put :update, id: @group, group: attributes_for(:topic_group, title: 'None of your business', description: nil)
          @group.reload
          expect(@group.title).not_to eq('None of your business')
        end

        it 're-renders the :edit template' do
          put :update, id: @group, group: attributes_for(:invalid_group)
          expect(response).to render_template :edit
        end
      end
    end

    describe 'DELETE #destroy' do
      before(:each) do
        @group = create(:learning_group)
      end

      it 'deletes the group from the database' do
        expect {
          delete :destroy, id: @group
        }.to change(Group, :count).by(-1)
      end

      it 'redirects to the groups index page' do
        delete :destroy, id: @group
        expect(response).to redirect_to groups_path
      end
    end
  end
end