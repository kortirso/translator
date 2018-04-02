RSpec.describe TasksController, type: :controller do
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

  describe 'GET #show' do
    context 'if user is signed in' do
      sign_in_user

      context 'try access unexisted task' do
        before { get :show, params: { id: 111, locale: 'en' } }

        it 'should render 404 page' do
          expect(response).to render_template 'shared/404'
        end
      end

      context 'try access his active task' do
        let!(:task) { create :task, user: @current_user }
        before { get :show, params: { id: task.id, locale: 'en' } }

        it 'should render 404 page' do
          expect(response).to render_template 'shared/404'
        end
      end

      context 'try access his completed task' do
        let!(:task) { create :task, :done, user: @current_user }
        before { get :show, params: { id: task.id, locale: 'en' } }

        it 'should collect an array of translations in @translations' do
          expect(assigns(:translations)).to match_array([])
        end

        it 'should render tasks#show' do
          expect(response).to render_template :show
        end
      end

      context 'try access not his task' do
        it 'should render 404 page' do
          get :show, params: { id: 100, locale: 'en' }

          expect(response).to render_template 'shared/404'
        end
      end
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
        let!(:task) { create :task, :done, user: @current_user }

        it 'should call activate method for task' do
          expect_any_instance_of(Task).to receive(:activate)

          patch :update, params: { id: task.id, translation: { '607' => { result: 'About LangTool' } }, locale: 'en', format: :js }
        end

        it 'and should redirect_to tasks_path' do
          patch :update, params: { id: task.id, translation: { '607' => { result: 'About LangTool' } }, locale: 'en', format: :js }

          expect(response).to redirect_to tasks_en_path
        end
      end
    end
  end
end
