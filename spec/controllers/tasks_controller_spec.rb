RSpec.describe TasksController, type: :controller do
    describe 'POST #create' do
        context 'with valid attributes' do
            it 'saves the new task in the DB' do
                expect { post :create, params: { task: { to: 'ru', file: File.open("#{Rails.root}/config/locales/en.yml") } }, format: :js }.to change(Task, :count).by(1)
            end
        end

        context 'with invalid attributes' do
            it 'does not save the new task in the DB' do
                expect { post :create, params: { task: { to: '', file: File.open("#{Rails.root}/config/locales/en.yml") } }, format: :js }.to_not change(Task, :count)
            end

            it 'redirect_to tasks if there is no file' do
                post :create, params: { task: { to: '', file: nil } }, format: :js

                expect(response).to redirect_to tasks_path
            end
        end
    end
end