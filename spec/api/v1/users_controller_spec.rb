describe 'Users API' do
    describe 'POST #create' do
        context 'with valid data' do
            let(:request) { post '/api/v1/users', params: { user: { email: 'some@email.com', username: 'username', password: 'password12', password_confirmation: 'password12' }, format: :json } }

            it 'creates new user record' do
                expect { request }.to change(User, :count).by(1)
            end

            context 'in answer' do
                before { request }

                it 'returns 201 status' do
                    expect(response.code).to eq '201'
                end

                it 'returns serialized user object' do
                    expect(response.body).to be_json_eql(UserSerializer.new(User.last).serializable_hash.to_json).at_path('user')
                end

                %w[id email username access_token].each do |attr|
                    it "contains #{attr}" do
                        expect(response.body).to have_json_path("user/#{attr}")
                    end
                end

                it 'access_token is not empty' do
                    expect(JSON.parse(response.body)['user']['access_token']).to_not eq('')
                end

                %w[password encrypted_password].each do |attr|
                    it "doesnt contain #{attr}" do
                        expect(response.body).to_not have_json_path("user/#{attr}")
                    end
                end
            end
        end

        context 'with invalid data' do
            let!(:user) { create :user }
            let(:request) { post '/api/v1/users', params: { user: { email: user.email, username: user.username, password: 'password12', password_confirmation: 'password12' }, format: :json } }

            it 'doesnt create new user record' do
                expect { request }.to_not change(User, :count)
            end

            context 'in answer' do
                before { request }

                it 'returns 409 status' do
                    expect(response.code).to eq '409'
                end

                it 'returns error text' do
                    expect(JSON.parse(response.body)).to eq('error' => 'User creation error')
                end
            end
        end
    end

    describe 'GET #access_token' do
        let!(:user) { create :user }

        context 'with valid data' do
            let(:request) { get '/api/v1/users/access_token', params: { email: user.email, password: user.password, format: :json } }

            context 'in answer' do
                before { request }

                it 'returns 200 status' do
                    expect(response.code).to eq '200'
                end

                it 'returns serialized user object' do
                    user.reload

                    expect(response.body).to be_json_eql(UserSerializer.new(user).serializable_hash.to_json).at_path('user')
                end

                it 'access_token is not empty' do
                    expect(JSON.parse(response.body)['user']['access_token']).to_not eq('')
                end
            end
        end

        context 'with invalid data' do
            let(:request) { get '/api/v1/users/access_token', params: { email: 'wrong@gmail.com', password: user.password, format: :json } }

            context 'in answer' do
                before { request }

                it 'returns 401 status' do
                    expect(response.code).to eq '401'
                end

                it 'returns error text' do
                    expect(JSON.parse(response.body)).to eq('error' => 'Unauthorized')
                end
            end
        end
    end

    describe 'GET #me' do
        it_behaves_like 'API Auth'

        context 'for existed users' do
            let!(:user) { create :user }
            before { get '/api/v1/users/me', params: { email: user.email, access_token: user.access_token, format: :json } }

            it 'returns 200 status' do
                expect(response.code).to eq '200'
            end

            it 'returns serialized user object' do
                expect(response.body).to be_json_eql(UserSerializer.new(user).serializable_hash.to_json).at_path('user')
            end
        end

        def do_request(options = {})
            get '/api/v1/users/me', params: { format: :json }.merge(options)
        end
    end
end
