RSpec.describe TranslationsController, type: :controller do
    describe 'GET #index' do
        context 'guest' do
            it 'should render 404 page' do
                get :index, params: { locale: 'en' }

                expect(response).to render_template 'shared/404'
            end
        end

        context 'user' do
            sign_in_user

            it 'should render 404 page' do
                get :index, params: { locale: 'en' }

                expect(response).to render_template 'shared/404'
            end
        end

        context 'admin' do
            sign_in_admin

            it 'should render translations#index' do
                get :index, params: { locale: 'en' }

                expect(response).to render_template :index
            end
        end
    end
end
