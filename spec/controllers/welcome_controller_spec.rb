RSpec.describe WelcomeController, type: :controller do
  describe 'GET #index' do
    context 'for html request' do
      it 'renders tasks#index' do
        get :index, params: { locale: 'en' }

        expect(response).to render_template :index
      end
    end

    context 'for json request' do
      it 'should render json' do
        get :index, params: { locale: 'en', format: :json }

        resp = JSON.parse(response.body)

        expect(resp['tasks']).to_not eq nil
        expect(resp['locales']).to_not eq nil
        expect(resp['frameworks']).to_not eq nil
      end
    end
  end
end
