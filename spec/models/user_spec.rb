RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:tasks).dependent(:destroy) }
  it { should have_many(:identities).dependent(:destroy) }
  it { should have_many(:guests).dependent(:destroy) }

  it 'should be valid' do
    user = create :user

    expect(user).to be_valid
  end

  it 'should be valid with email and password' do
    user = User.new email: 'example@gmail.com', password: 'password12'

    expect(user).to be_valid
  end

  it 'should be invalid without email' do
    user = User.new(email: nil)
    user.valid?

    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'should be invalid without password' do
    user = User.new(password: nil)
    user.valid?

    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'should be invalid with a duplicate email' do
    User.create(username: 'tester1', email: 'example@gmail.com', password: 'password12', confirmed_at: DateTime.now)
    user = User.new(username: 'tester2', email: 'example@gmail.com', password: 'password12')
    user.valid?

    expect(user.errors[:email]).to include('has already been taken')
  end

  describe 'callbacks' do
    context 'send_welcome_email' do
      let!(:user) { create :user }

      it 'does not execute job if confirmed_at does not changed' do
        expect(WelcomeLetterJob).to_not receive(:perform_later)

        user.save
      end

      it 'executes job if confirmed_at changed' do
        expect(WelcomeLetterJob).to receive(:perform_later)

        user.confirmed_at = DateTime.now
        user.save
      end
    end
  end

  describe 'class methods' do
    context '.find_for_oauth' do
      let(:oauth) { create :oauth, :with_credentials }

      context 'for unexisted user and identity' do
        it 'creates new User' do
          expect { User.find_for_oauth(oauth) }.to change(User, :count).by(1)
        end

        it 'returns new User' do
          expect(User.find_for_oauth(oauth)).to eq User.last
        end

        it 'creates new Identity' do
          expect { User.find_for_oauth(oauth) }.to change(Identity, :count).by(1)
        end

        it 'new Identity has params from oauth and belongs to new User' do
          user = User.find_for_oauth(oauth)
          identity = Identity.last

          expect(identity.uid).to eq oauth.uid
          expect(identity.provider).to eq oauth.provider
          expect(identity.user).to eq user
        end
      end

      context 'for existed user without identity' do
        let!(:user) { create :user, email: oauth.info[:email] }

        it 'does not create new User' do
          expect { User.find_for_oauth(oauth) }.to_not change(User, :count)
        end

        it 'returns existed user' do
          expect(User.find_for_oauth(oauth)).to eq user
        end

        it 'creates new Identity' do
          expect { User.find_for_oauth(oauth) }.to change(Identity, :count).by(1)
        end

        it 'new Identity has params from oauth and belongs to existed user' do
          User.find_for_oauth(oauth)
          identity = Identity.last

          expect(identity.uid).to eq oauth.uid
          expect(identity.provider).to eq oauth.provider
          expect(identity.user).to eq user
        end
      end

      context 'for existed user with identity' do
        let!(:user) { create :user, email: oauth.info[:email] }
        let!(:identity) { create :identity, uid: oauth.uid, user: user }

        it 'does not create new User' do
          expect { User.find_for_oauth(oauth) }.to_not change(User, :count)
        end

        it 'returns existed user' do
          expect(User.find_for_oauth(oauth)).to eq user
        end

        it 'does not create new Identity' do
          expect { User.find_for_oauth(oauth) }.to_not change(Identity, :count)
        end
      end
    end
  end

  describe 'methods' do
    context '.admin?' do
      let!(:user_1) { create :user, :admin }
      let!(:user_2) { create :user }

      it 'returns true if user is admin' do
        expect(user_1.admin?).to eq true
      end

      it 'returns false if user is not admin' do
        expect(user_2.admin?).to eq false
      end
    end

    context '.translator?' do
      let!(:user_1) { create :user, :translator }
      let!(:user_2) { create :user }

      it 'returns true if user is translator' do
        expect(user_1.translator?).to eq true
      end

      it 'returns false if user is not translator' do
        expect(user_2.translator?).to eq false
      end
    end

    context '.editor?' do
      let!(:user_1) { create :user, :admin }
      let!(:user_2) { create :user, :translator }
      let!(:user_3) { create :user }

      it 'returns true if user is admin' do
        expect(user_1.editor?).to eq true
      end

      it 'returns true if user is translator' do
        expect(user_2.editor?).to eq true
      end

      it 'returns false if user is not editor' do
        expect(user_3.editor?).to eq false
      end
    end

    context '.forget' do
      let!(:user) { create :user }
      before { user.remember }

      it 'updates remember_digest param to nil' do
        expect { user.forget }.to change(user, :remember_digest).to(nil)
      end
    end

    context '.authenticated?' do
      let!(:user) { create :user, remember_digest: nil }

      it 'returns false for nil remember_digest' do
        expect(user.authenticated?('')).to eq false
      end

      it 'returns false for wrong digest/token' do
        token = SecureRandom.urlsafe_base64
        user.update_attribute(:remember_digest, User.digest(token))

        expect(user.authenticated?(token + '1')).to eq false
      end

      it 'returns true for correct digest' do
        token = SecureRandom.urlsafe_base64
        user.update_attribute(:remember_digest, User.digest(token))

        expect(user.authenticated?(token)).to eq true
      end
    end
  end
end
