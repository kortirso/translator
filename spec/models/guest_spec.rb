RSpec.describe Guest, type: :model do
  it { should belong_to :user }
  it { should have_many(:tasks).dependent(:destroy) }

  it 'should be valid' do
    guest = create :guest

    expect(guest).to be_valid
  end

  describe 'methods' do
    context '.attach_to_user' do
      let!(:guest) { create :guest }
      let!(:user) { create :user }
      let!(:task) { create :task, personable: guest }

      it 'updates guest for belonging to user' do
        expect { guest.attach_to_user(user) }.to change(guest, :user_id).to(user.id)
      end

      it 'updates guest tasks for belonging to user' do
        guest.attach_to_user(user)
        task.reload

        expect(task.personable).to eq user
      end
    end
  end
end
