describe 'Users API' do
    describe 'POST #create' do
        context 'with valid data' do
            let(:request) { post '/api/v1/users', params: { user: { email: 'some@email.com', username: 'username', password: 'password12', password_confirmation: 'password12' } } }

            it 'creates new user record' do
                expect { request }.to change(User, :count).by(1)
            end

            context 'in answer' do
                before { request }

                it 'returns 201 status' do
                    expect(response.code).to eq '201'
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
            let(:request) { post '/api/v1/users', params: { user: { email: user.email, username: user.username, password: 'password12', password_confirmation: 'password12' } } }

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
            let(:request) { get '/api/v1/users/access_token', params: { email: user.email, password: user.password } }

            context 'in answer' do
                before { request }

                it 'returns 200 status' do
                    expect(response.code).to eq '200'
                end

                it 'access_token is not empty' do
                    expect(JSON.parse(response.body)['user']['access_token']).to_not eq('')
                end
            end
        end

        context 'with invalid data' do
            let(:request) { get '/api/v1/users/access_token', params: { email: 'wrong@gmail.com', password: user.password } }

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
end
