RSpec.describe WelcomeLetterJob, type: :job do
  let!(:user) { create :user }

  it 'executes method welcome_email of UserMailer' do
    expect(UserMailer).to receive(:welcome_email).and_call_original

    WelcomeLetterJob.perform_now(user)
  end
end
