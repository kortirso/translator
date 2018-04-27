RSpec.describe UserMailer, type: :mailer do
  describe 'welcome_email' do
    let!(:user) { create :user }
    let(:mail) { UserMailer.welcome_email(user: user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Message from LangTool')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['postmaster@langtool.tech'])
    end
  end
end
