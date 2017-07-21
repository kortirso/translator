describe 'Guest API' do
    describe 'GET #access_token' do
        before { get '/api/v1/guest/access_token', params: { format: :js } }

        it 'returns 201 status' do
            expect(response.code).to eq '201'
        end

        it 'contains access_token for guest' do
            expect(response.body).to have_json_path('access_token')
            expect(JSON.parse(response.body)['access_token'].size).to eq TokenService::KEY_SIZE * 2
        end
    end

    describe 'POST #create' do
        it_behaves_like 'API Guest Auth'

        context 'for existed users' do
            let(:access_token) { TokenService.call }

            context 'with valid data' do
                let(:request) { post '/api/v1/guest', params: { to: 'ru', file: File.open("#{Rails.root}/config/locales/en.yml"), access_token: access_token, format: :js } }

                it 'creates new task record' do
                    expect { request }.to change(Task, :count).by(1)
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
                let(:request) { post '/api/v1/guest', params: { to: '', file: File.open("#{Rails.root}/config/locales/en.yml"), access_token: access_token, format: :js } }

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
            post '/api/v1/guest', params: { format: :js }.merge(options)
        end
    end

    describe 'GET #index' do
        it_behaves_like 'API Guest Auth'

        context 'for existed users' do
            let(:access_token) { TokenService.call }
            let!(:task) { create :task, uid: access_token }
            let!(:other_task) { create :task }
            before { get '/api/v1/guest', params: { access_token: access_token, format: :js } }

            it 'returns 200 status' do
                expect(response.code).to eq '200'
            end

            it 'contains list of guest tasks' do
                expect(response.body).to be_json_eql(TaskSerializer.new(task).serializable_hash.to_json).at_path('tasks/0')
            end

            it 'contains only guest tasks' do
                expect(JSON.parse(response.body)['tasks'].size).to eq Task.for_guest(access_token).size
                expect(JSON.parse(response.body)['tasks'].size).to_not eq Task.count
            end
        end

        def do_request(options = {})
            get '/api/v1/guest', params: { format: :js }.merge(options)
        end
    end

    describe 'DELETE #destroy' do
        let(:access_token) { TokenService.call }
        let!(:task) { create :task, uid: access_token }
        it_behaves_like 'API Guest Auth'

        context 'for existed users' do
            context 'for their own objects' do
                let(:request) { delete "/api/v1/guest/#{task.id}", params: { access_token: access_token, format: :js } }

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
                let!(:other_task) { create :task }
                let(:request) { delete "/api/v1/guest/#{other_task.id}", params: { access_token: access_token, format: :js } }

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
            delete "/api/v1/guest/#{task.id}", params: { format: :js }.merge(options)
        end
    end
end
