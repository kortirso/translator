RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    context 'for html request' do
      it 'renders tasks#index' do
        get :index, params: { locale: 'en' }

        expect(response).to render_template :index
      end
    end

    context 'for json request' do

      it 'renders json' do
        get :index, params: { locale: 'en', format: :json }

        resp = JSON.parse(response.body)

        expect(resp['tasks']).to_not eq nil
        expect(resp['locales']).to_not eq nil
        expect(resp['frameworks']).to_not eq nil
      end
    end
  end

  describe 'POST #create' do
    let!(:framework) { create :framework }
    let(:request) { post :create, params: { locale: 'en', file: Rack::Test::UploadedFile.new("#{Rails.root}/spec/test_files/ru.yml"), framework: framework.name, to: 'en' } }

    it 'creates new Task' do
      expect { request }.to change { Task.count }.by(1)
    end

    it 'and returns status 201' do
      request

      expect(response.status).to eq 201
    end

    it 'and returns json with task' do
      request

      expect(JSON.parse(response.body)['task']).to_not eq nil
    end
  end

  describe 'PATCH #update' do
    context 'guest' do
      let!(:task) { create :task }

      it 'does not change task' do
        expect { patch :update, params: { id: task.id, translation: { '607' => { result: 'About LangTool' } }, locale: 'en', format: :js } }.to_not change { task }
      end
    end

    context 'user' do
      sign_in_user

      context 'if task belongs to another user' do
        let!(:task) { create :task }

        it 'does not change task' do
          expect { patch :update, params: { id: task.id, translation: { '607' => { result: 'About LangTool' } }, locale: 'en', format: :js } }.to_not change { task }
        end
      end

      context 'if task belongs to user' do
        let!(:task) { create :task, :done, personable: @current_user }

        it 'calls activate method for task' do
          expect_any_instance_of(Task).to receive(:activate)

          patch :update, params: { id: task.id, translation: { '607' => { result: 'About LangTool' } }, locale: 'en', format: :js }
        end

        it 'and redirects to tasks_path' do
          patch :update, params: { id: task.id, translation: { '607' => { result: 'About LangTool' } }, locale: 'en', format: :js }

          expect(response).to redirect_to tasks_en_path
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'if user is signed in' do
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
        let(:request){ delete :destroy, params: { id: task.id, locale: 'en' } }

        it 'destroys task' do
          expect { request }.to change { Task.count }.by(-1)
        end

        it 'and returns status 200' do
          request

          expect(response.status).to eq 200
        end

        it 'and renders json' do
          request

          expect(JSON.parse(response.body)).to eq('success' => 'Task destroyed successfully')
        end
      end
    end
  end
end
