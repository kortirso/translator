RSpec.describe Workspace::TasksController, type: :controller do
  describe 'GET #index' do
    it_behaves_like 'Workspace Auth'

    context 'logged user' do
      sign_in_user

      context 'for html request' do
        it 'renders workspace#index' do
          get :index, params: { locale: 'en' }

          expect(response).to render_template :index
        end
      end

      context 'for json request' do
        it 'renders json' do
          get :index, params: { locale: 'en', format: :json }

          resp = JSON.parse(response.body)

          expect(resp['tasks']).to_not eq nil
        end
      end
    end

    def do_request
      get :index, params: { locale: 'en' }
    end
  end

  describe 'GET #show' do
    it_behaves_like 'Workspace Auth'

    context 'logged user' do
      sign_in_user

      context 'for html request' do
        context 'for unexisted task' do
          it 'renders error page' do
            get :show, params: { id: 999, locale: 'en' }

            expect(response).to render_template 'shared/404'
          end
        end

        context 'for existed task' do
          let!(:task) { create :task, personable: @current_user }

          it 'renders workspace#show' do
            get :show, params: { id: task.id, locale: 'en' }

            expect(response).to render_template :show
          end
        end
      end

      context 'for json request' do
        let!(:task) { create :task, personable: @current_user }

        it 'renders json' do
          get :show, params: { id: task.id, locale: 'en', format: :json }

          resp = JSON.parse(response.body)

          expect(resp['task']).to_not eq nil
        end
      end
    end

    def do_request
      get :show, params: { id: 999, locale: 'en' }
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'Workspace Auth'

    context 'logged user' do
      sign_in_user

      context 'try delete unexisted task' do
        it 'renders 404 page' do
          delete :destroy, params: { id: 111, locale: 'en' }

          expect(response).to render_template 'shared/404'
        end
      end

      context 'try delete not his task' do
        it 'renders 404 page' do
          delete :destroy, params: { id: 100, locale: 'en' }

          expect(response).to render_template 'shared/404'
        end
      end

      context 'try delete his active task' do
        let!(:task) { create :task, personable: @current_user }

        it 'renders 404 page' do
          delete :destroy, params: { id: task.id, locale: 'en' }

          expect(response).to render_template 'shared/404'
        end
      end

      context 'try delete his completed task' do
        let!(:task) { create :task, :done, personable: @current_user }
        let(:request) { delete :destroy, params: { id: task.id, locale: 'en' } }

        it 'destroys task' do
          expect { request }.to change { Task.count }.by(-1)
        end

        it 'and returns status 303' do
          request

          expect(response.status).to eq 303
        end

        it 'and redirects to workspace path' do
          request

          expect(response).to redirect_to workspace_tasks_en_path
        end
      end
    end

    def do_request
      delete :destroy, params: { id: 999, locale: 'en' }
    end
  end
end
