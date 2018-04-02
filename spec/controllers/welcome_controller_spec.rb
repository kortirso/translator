RSpec.describe WelcomeController, type: :controller do
  describe 'GET #index' do
    context 'for html request' do
      before { get :index, params: { locale: 'en' } }

      it 'should render tasks#index' do
        expect(response).to render_template :index
      end
    end

    context 'for json request' do
      before { get :index, params: { locale: 'en', format: :json } }

      it 'should render json' do
        resp = JSON.parse(response.body)

        expect(resp['tasks']).to_not eq nil
        expect(resp['locales']).to_not eq nil
        expect(resp['frameworks']).to_not eq nil
      end
    end
  end
end
