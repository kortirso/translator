RSpec.describe TokenService, type: :service do
  describe '.call' do
    it 'returns string with secure key' do
      expect(TokenService.call.is_a?(String)).to eq true
    end

    it 'string size is 64' do
      expect(TokenService.call.size).to eq TokenService::KEY_SIZE * 2
    end
  end
end
