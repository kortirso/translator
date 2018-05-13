RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    it_behaves_like 'Workspace Auth'

    context 'logged user' do
      sign_in_user

      it 'renders workspace#index' do
        get :index, params: { locale: 'en' }

        expect(response).to render_template :index
      end
    end

    def do_request
      get :index, params: { locale: 'en' }
    end
  end
end
