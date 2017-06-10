RSpec.describe TranslationsController, type: :controller do
    describe 'POST #create' do
        context 'for guest' do
            it 'do nothing' do
                post :create, params: { translation: {}, locale: 'en' }

                expect(response).to have_http_status(:ok)
            end
        end

        context 'for user' do
            sign_in_user

            context 'if task does not exist' do
                it 'do nothing' do
                    post :create, params: { task_id: 111, translation: {}, locale: 'en' }

                    expect(response).to have_http_status(:ok)
                end
            end

            context 'if task belongs to another user' do
                let!(:task) { create :task }

                it 'do nothing' do
                    post :create, params: { task_id: 111, translation: {}, locale: 'en' }

                    expect(response).to have_http_status(:ok)
                end
            end

            context 'if task belongs to user' do
                let!(:task) { create :task, :done, user: @current_user }

                it 'should call activate method for task' do
                    expect_any_instance_of(Task).to receive(:activate)

                    post :create, params: { task_id: task.id, translation: { '607' => { result: 'About LangTool' } }, locale: 'en' }
                end

                it 'and should redirect_to tasks_path' do
                    post :create, params: { task_id: task.id, translation: { '607' => { result: 'About LangTool' } }, locale: 'en' }

                    expect(response).to redirect_to tasks_en_path
                end
            end
        end
    end
end
