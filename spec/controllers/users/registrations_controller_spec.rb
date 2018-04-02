RSpec.describe Users::RegistrationsController, type: :controller do
  it { should_not use_before_action :verify_authenticity_token }
  it { should use_after_action :update_token }

  describe '.update_token' do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
    end

    it 'updates token for new user' do
      post :create, params: { locale: 'en', user: { email: '1@email.com', password: '12345678' } }

      expect(User.last.access_token.size).to eq TokenService::KEY_SIZE * 2
    end
  end
end
