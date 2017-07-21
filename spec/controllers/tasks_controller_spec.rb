RSpec.describe TasksController, type: :controller do
    describe 'GET #index' do
        let!(:locale) { create :locale, :en }
        before { get :index, params: { locale: 'en' } }

        it 'should render tasks#index' do
            expect(response).to render_template :index
        end
    end

    describe 'GET #show' do
        context 'if user is signed in' do
            sign_in_user

            context 'and try access his active task' do
                let!(:task) { create :task, user: @current_user }
                before { get :show, params: { id: task.id, locale: 'en' } }

                it 'should render tasks#show' do
                    expect(response).to render_template 'shared/404'
                end
            end

            context 'and try access his done task' do
                let!(:task) { create :task, :done, user: @current_user }
                before { get :show, params: { id: task.id, locale: 'en' } }

                it 'should collect an array of translations in @translations' do
                    expect(assigns(:translations)).to match_array([])
                end

                it 'should render tasks#show' do
                    expect(response).to render_template :show
                end
            end

            context 'and try access not his task' do
                it 'should render 404' do
                    get :show, params: { id: 100, locale: 'en' }

                    expect(response).to render_template 'shared/404'
                end
            end
        end
    end
end
