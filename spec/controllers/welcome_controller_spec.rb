RSpec.describe WelcomeController, type: :controller do
    describe 'GET #index' do
        it 'should render welcome#index' do
            get :index, params: { locale: 'en' }

            expect(response).to render_template :index
        end
    end
end