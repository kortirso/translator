RSpec.describe UsersController, type: :controller do
    describe 'GET #index' do
        context 'if user is not signed in' do
            it 'should render users#index' do
                get :index, params: { locale: 'en' }

                expect(response).to render_template :index
            end
        end

        context 'if user signed in' do
            sign_in_user

            it 'should redirect_to user page' do
                get :index, params: { locale: 'en' }

                expect(response).to redirect_to @current_user
            end
        end
    end

    describe 'GET #show' do
        context 'with invalid attributes it should render 404' do
            it 'if user is not signed in' do
                get :show, params: { id: 1, locale: 'en' }

                expect(response).to render_template 'shared/404'
            end

            context 'if user is signed in' do
                let!(:user) { create :user }
                sign_in_user

                it 'but user_id is not exist' do
                    get :show, params: { id: 10000, locale: 'en' }

                    expect(response).to render_template 'shared/404'
                end

                it 'but user try access another user page' do
                    get :show, params: { id: user.id, locale: 'en' }

                    expect(response).to render_template 'shared/404'
                end
            end
        end

        context 'with valid attributes' do
            sign_in_user

            it 'should render users#show' do
                get :show, params: { id: @current_user.id, locale: 'en' }

                expect(response).to render_template :show
            end
        end
    end
end