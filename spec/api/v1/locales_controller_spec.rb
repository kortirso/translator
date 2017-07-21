describe 'Locales API' do
    describe 'GET #index' do
        let!(:locale_1) { create :locale, :en }
        let!(:locale_2) { create :locale, :ru }
        before { get '/api/v1/locales', params: { format: :js } }

        it 'returns 200 status' do
            expect(response.code).to eq '200'
        end

        it 'contains list of locales' do
            expect(JSON.parse(response.body)['locales'].size).to eq 2
        end

        it 'contains serialized locale objects' do
            expect(response.body).to be_json_eql(LocaleSerializer.new(locale_1).serializable_hash.to_json).at_path('locales/0')
            expect(response.body).to be_json_eql(LocaleSerializer.new(locale_2).serializable_hash.to_json).at_path('locales/1')
        end
    end
end
