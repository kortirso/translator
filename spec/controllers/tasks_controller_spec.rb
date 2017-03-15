RSpec.describe TasksController, type: :controller do
    describe 'POST #create' do
        context 'with valid attributes' do
            it 'saves the new task in the DB' do
                expect { post :create, task: attributes_for(:task), format: :js }.to change(Task, :count).by(1)
            end
        end

        context 'with invalid attributes' do
            it 'does not save the new task in the DB' do
                expect { post :create, task: attributes_for(:invalid_task), format: :js }.to_not change(Task, :count)
            end
        end
    end
end