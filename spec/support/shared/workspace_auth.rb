shared_examples_for 'Workspace Auth' do
  context 'for unlogged users' do
    it 'redirects to login page' do
      do_request

      expect(response).to redirect_to new_user_session_en_path
    end
  end
end
