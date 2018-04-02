RSpec.describe Users::OmniauthController, type: :controller do
  describe 'localized' do
    context 'for facebook' do
      before { get 'localized', params: { locale: 'en', provider: 'facebook' } }

      it 'redirects to user_facebook_omniauth_authorize path' do
        expect(response).to redirect_to user_facebook_omniauth_authorize_path
      end
    end

    context 'for github' do
      before { get 'localized', params: { locale: 'en', provider: 'github' } }

      it 'redirects to user_github_omniauth_authorize path' do
        expect(response).to redirect_to user_github_omniauth_authorize_path
      end
    end

    context 'for other providers' do
      before { get 'localized', params: { locale: 'en', provider: 'unknown' } }

      it 'redirects to root path' do
        expect(response).to redirect_to root_en_path
      end
    end
  end
end
