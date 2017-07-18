describe 'Users API' do
    describe 'POST #create' do
        context 'with valid data' do
            before { post '/api/v1/users', params: { user: { email: 'some@email.com', username: 'username', password: 'password12', password_confirmation: 'password12' } } }

            it 'creates new user record' do
                expect { post '/api/v1/users', params: { user: { email: 'some1@email.com', username: 'username1', password: 'password12', password_confirmation: 'password12' } } }.to change(User, :count).by(1)
            end

            it 'returns 201 status' do
                expect(response.code).to eq '201'
            end

            %w(id email username access_token).each do |attr|
                it "contains #{attr}" do
                    expect(response.body).to have_json_path("user/#{attr}")
                end
            end

            %w(password encrypted_password).each do |attr|
                it "doesnt contain #{attr}" do
                    expect(response.body).to_not have_json_path("user/#{attr}")
                end
            end
        end

        context 'with invalid data' do
            let!(:user) { create :user }
            before { post '/api/v1/users', params: { user: { email: user.email, username: user.username, password: 'password12', password_confirmation: 'password12' } } }

            it 'doesnt create new user record' do
                expect { post '/api/v1/users', params: { user: { email: user.email, username: user.username, password: 'password12', password_confirmation: 'password12' } } }.to_not change(User, :count)
            end

            it 'returns 409 status' do
                expect(response.code).to eq '409'
            end

            it 'returns error text' do
                expect(JSON.parse(response.body)).to eq({"error"=>"User creation error"})
            end
        end
    end
end