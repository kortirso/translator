RSpec.describe TranslationsController, type: :controller do
    describe 'GET #index' do
        it 'should render index page' do
            get :index

            expect(response).to render_template :index
        end
    end
end