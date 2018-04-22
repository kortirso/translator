RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  it { should use_before_action :provides_callback }

  describe 'facebook' do
    context 'without info from provider' do
      before :each do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = nil
      end
      before { get 'facebook' }

      it 'redirects to root path' do
        expect(response).to redirect_to root_en_path
      end

      it 'and sets flash message with error' do
        expect(request.flash[:error]).to eq 'Access Error'
      end
    end

    context 'without email in info from provider' do
      before :each do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = facebook_invalid_hash
      end
      before { get 'facebook' }

      it 'redirects to root path' do
        expect(response).to redirect_to root_en_path
      end

      it 'and sets flash message with manifesto_username' do
        expect(request.flash[:manifesto_username]).to eq true
      end
    end

    context 'with info from provider' do
      before :each do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = facebook_hash
      end

      context 'for new user' do
        before { get 'facebook' }

        it 'redirects to user path' do
          expect(response).to redirect_to root_en_path
        end
      end

      context 'for existed user' do
        let!(:user) { create :user, :confirmed, email: 'example_facebook@xyze.it' }

        it 'redirects to user path' do
          get 'facebook'

          expect(response).to redirect_to root_en_path
        end
      end
    end
  end

  describe 'github' do
    context 'without info from provider' do
      before :each do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = nil
      end
      before { get 'github' }

      it 'redirects to root path' do
        expect(response).to redirect_to root_en_path
      end

      it 'and sets flash message with error' do
        expect(request.flash[:error]).to eq 'Access Error'
      end
    end

    context 'without email in info from provider' do
      before :each do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = github_invalid_hash
      end
      before { get 'github' }

      it 'redirects to root path' do
        expect(response).to redirect_to root_en_path
      end

      it 'and sets flash message with manifesto_username' do
        expect(request.flash[:manifesto_username]).to eq true
      end
    end

    context 'with info from provider' do
      before :each do
        request.env['devise.mapping'] = Devise.mappings[:user]
        request.env['omniauth.auth'] = github_hash
      end

      context 'for new user' do
        before { get 'github' }

        it 'redirects to user path' do
          expect(response).to redirect_to root_en_path
        end
      end

      context 'for existed user' do
        let!(:user) { create :user, :confirmed, email: 'example_facebook@xyze.it' }

        it 'redirects to user path' do
          get 'github'

          expect(response).to redirect_to root_en_path
        end
      end
    end
  end
end
