RSpec.describe FormatsController, type: :controller do
  describe 'GET #index' do
    it 'renders formats#index' do
      get :index, params: { locale: 'en' }

      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    context 'for unknown format' do
      it 'redirects to erro page' do
        get :show, params: { format_name: 'bugaga', locale: 'en' }

        expect(response).to render_template 'shared/404'
      end
    end

    context 'for existed format' do
      it 'renders formats#show' do
        get :show, params: { format_name: 'rails', locale: 'en' }

        expect(response).to render_template :rails
      end
    end
  end
end
