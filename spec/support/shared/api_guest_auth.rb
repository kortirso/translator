shared_examples_for 'API Guest Auth' do
  it 'returns 401 status if there is no access_token' do
    do_request

    expect(response.status).to eq 401
    expect(JSON.parse(response.body)).to eq('error' => 'Unauthorized guest')
  end

  it 'returns 401 status if there is access_token, but its length is not 64' do
    do_request(access_token: '')

    expect(response.status).to eq 401
    expect(JSON.parse(response.body)).to eq('error' => 'Unauthorized guest')
  end
end
