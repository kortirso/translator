RSpec.describe Users::SessionsController, type: :controller do
  it { should_not use_before_action :verify_authenticity_token }
  it { should use_after_action :update_token }

  describe '.update_token' do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
    end
    let!(:user) { create :user }

    it 'updates token for user' do
      old_token = user.access_token

      post :create, params: { locale: 'en', user: { email: user.email, password: user.password } }
      user.reload

      expect(user.access_token).to_not eq old_token
    end
  end
end
