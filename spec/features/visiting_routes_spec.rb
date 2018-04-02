require_relative 'feature_helper'

RSpec.feature 'Visiting routes', type: :feature do
  describe 'Visit unknown route' do
    it 'redirects to error page' do
      visit '1'

      expect(page.has_content?('ERROR')).to eq true
    end
  end
end
