describe 'Tasks API' do
    describe 'POST #create' do
        it_behaves_like 'API Auth'

        context 'for existed users' do
            let!(:user) { create :user }

            context 'with valid data' do
                let(:request) { post '/api/v1/tasks', params: { to: 'ru', file: File.open("#{Rails.root}/config/locales/en.yml"), email: user.email, access_token: user.access_token, format: :js } }

                it 'creates new task record' do
                    expect { request }.to change(Task, :count).by(1)
                end

                it 'belongs to user' do
                    expect { request }.to change(user.tasks, :count).by(1)
                end

                context 'in answer' do
                    before { request }

                    it 'returns 201 status' do
                        expect(response.code).to eq '201'
                    end

                    it 'returns serialized task object' do
                        expect(response.body).to be_json_eql(TaskSerializer.new(Task.last).serializable_hash.to_json).at_path('task')
                    end
                end
            end

            context 'with invalid data' do
                let(:request) { post '/api/v1/tasks', params: { to: '', file: File.open("#{Rails.root}/config/locales/en.yml"), email: user.email, access_token: user.access_token, format: :js } }

                it 'does not create new task record' do
                    expect { request }.to_not change(Task, :count)
                end

                context 'in answer' do
                    before { request }

                    it 'returns 409 status' do
                        expect(response.code).to eq '409'
                    end

                    it 'returns error text' do
                        expect(JSON.parse(response.body)).to eq('error' => 'Task creation error')
                    end
                end
            end
        end

        def do_request(options = {})
            post '/api/v1/tasks', params: { format: :js }.merge(options)
        end
    end

    describe 'GET #index' do
        it_behaves_like 'API Auth'

        context 'for existed users' do
            let!(:user) { create :user }
            let!(:task) { create :task, user: user }
            let!(:other_task) { create :task }
            before { get '/api/v1/tasks', params: { email: user.email, access_token: user.access_token, format: :js } }

            it 'returns 200 status' do
                expect(response.code).to eq '200'
            end

            it 'contains list of user tasks' do
                expect(response.body).to be_json_eql(TaskSerializer.new(task).serializable_hash.to_json).at_path('tasks/0')
            end

            it 'contains only users tasks' do
                expect(JSON.parse(response.body)['tasks'].size).to eq user.tasks.size
                expect(JSON.parse(response.body)['tasks'].size).to_not eq Task.count
            end
        end

        def do_request(options = {})
            get '/api/v1/tasks', params: { format: :js }.merge(options)
        end
    end

    describe 'DELETE #destroy' do
        let!(:user) { create :user }
        let!(:task) { create :task, user: user }
        it_behaves_like 'API Auth'

        context 'for existed users' do
            context 'for their own objects' do
                let(:request) { delete "/api/v1/tasks/#{task.id}", params: { email: user.email, access_token: user.access_token, format: :js } }

                it 'destroys task object' do
                    expect { request }.to change(Task, :count).by(-1)
                end

                context 'in answer' do
                    before { request }

                    it 'returns 200 status' do
                        expect(response.code).to eq '200'
                    end

                    it 'returns success message' do
                        expect(JSON.parse(response.body)).to eq('success' => 'Task destroyed successfully')
                    end
                end
            end

            context 'for other objects' do
                let!(:other_user) { create :user }
                let!(:other_task) { create :task, user: other_user }
                let(:request) { delete "/api/v1/tasks/#{other_task.id}", params: { email: user.email, access_token: user.access_token, format: :js } }

                it 'does not destroy task object' do
                    expect { request }.to_not change(Task, :count)
                end

                context 'in answer' do
                    before { request }

                    it 'returns 404 status' do
                        expect(response.code).to eq '404'
                    end

                    it 'returns error message' do
                        expect(JSON.parse(response.body)).to eq('error' => 'Task not found')
                    end
                end
            end
        end

        def do_request(options = {})
            delete "/api/v1/tasks/#{task.id}", params: { format: :js }.merge(options)
        end
    end
end
