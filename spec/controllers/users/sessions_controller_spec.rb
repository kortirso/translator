RSpec.describe Users::SessionsController, type: :controller do
  it { should_not use_before_action :verify_authenticity_token }
  it { should use_after_action :remember_user }

  describe '.remember_user' do
    before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
    end
    let!(:user) { create :user }

    it 'updates cookies' do
    end
  end
end
