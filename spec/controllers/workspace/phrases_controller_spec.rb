RSpec.describe Workspace::PhrasesController, type: :controller do
  describe 'PATCH #update' do
    it_behaves_like 'Workspace Auth'

    context 'logged user' do
      sign_in_user

      context 'if phrase does not exist' do
        before { patch :update, params: { id: 999, locale: 'en' } }

        it 'returns status 404' do
          expect(response.status).to eq 404
        end

        it 'and returns error message' do
          expect(JSON.parse(response.body)).to eq('error' => 'Phrase does not exist')
        end
      end

      context 'if phrase exists' do
        let(:phrase) { create :phrase }
        let(:request) { patch :update, params: { id: phrase.id, phrase: { current_value: '123' }, locale: 'en' } }

        it 'updates current_value of phrase' do
          old_value = phrase.current_value
          request
          phrase.reload

          expect(phrase.current_value).to_not eq old_value
        end

        context 'in answer' do
          before { request }

          it 'returns status 200' do
            expect(response.status).to eq 200
          end

          it 'and returns position' do
            resp = JSON.parse(response.body)

            expect(resp['position']).to_not eq nil
          end
        end
      end
    end

    def do_request
      patch :update, params: { id: 999, locale: 'en' }
    end
  end
end
