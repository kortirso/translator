shared_examples_for 'API Auth' do
  context 'for unexisted users' do
    it 'returns 401 status if there is no email and/or access_token' do
      do_request

      expect(response.status).to eq 401
      expect(JSON.parse(response.body)).to eq('error' => 'Unauthorized')
    end

    it 'returns 401 status if email and/or access_token is invalid' do
      do_request(email: '', access_token: '')

      expect(response.status).to eq 401
      expect(JSON.parse(response.body)).to eq('error' => 'Unauthorized')
    end
  end
end
