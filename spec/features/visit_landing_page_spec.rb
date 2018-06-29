require_relative 'feature_helper'

RSpec.feature 'Visit landing page', type: :feature do
  describe 'Guest user' do
    it 'can see head text' do
      visit root_path

      expect(page).to have_content 'Free service for automatic localization of your applications'
    end
  end
end
