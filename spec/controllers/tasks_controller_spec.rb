RSpec.describe TasksController, type: :controller do
    describe 'POST #create' do
        context 'with valid attributes' do
            it 'saves the new task in the DB' do
                skip
                expect { post :create, params: { task: {from: 'en', to: 'ru' } }, format: :js }.to change(Task, :count).by(1)
            end
        end

        context 'with invalid attributes' do
            it 'does not save the new task in the DB' do
                expect { post :create, params: { task: {from: 'en', to: '' } }, format: :js }.to_not change(Task, :count)
            end
        end
    end
end