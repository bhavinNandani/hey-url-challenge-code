# frozen_string_literal: true

require 'rails_helper'
require 'webdrivers'

# WebDrivers Gem
# https://github.com/titusfortner/webdrivers
#
# Official Guides about System Testing
# https://api.rubyonrails.org/v5.2/classes/ActionDispatch/SystemTestCase.html

RSpec.describe 'Short Urls', type: :system do
  FactoryBot.create_list(:url, 15)
  before do
    driven_by :selenium, using: :chrome
    # If using Firefox
    # driven_by :selenium, using: :firefox
    #
    # If running on a virtual machine or similar that does not have a UI, use
    # a headless driver
    # driven_by :selenium, using: :headless_chrome
    # driven_by :selenium, using: :headless_firefox
  end

  describe 'index' do
    it 'shows a list of short urls' do
      visit root_path
      expect(page).to have_text('HeyURL!')
      expect(all('tr').count).to eq(11) # 1 added for the header
    end
  end

  describe 'show' do
    it 'shows a panel of stats for a given short url' do
      visit url_path(Url.last.short_url)
      text_ = "Stats for #{Capybara.app_host}:#{Capybara.current_session.server.port}#{visit_path(Url.last.short_url)}"

      assert_selector 'h4', text: text_
    end

    context 'when not found' do
      it 'shows a 404 page' do
        # visit url_path('NOTFOUND')

        # assert_raises(ActionController::RoutingError) do
        #   visit url_path('NOTFOUND')
        # end
        # expect page to be a 404
      end
    end
  end

  describe 'create' do
    last_record = nil
    context 'when url is valid' do
      it 'creates the short url' do
        visit '/'

        fill_in 'url[original_url]', with: 'https://www.google.com/'

        click_on 'Shorten URL'

        assert_selector '#error-div', text: 'Url was successfully created.'
        last_record = Url.last
      end

      it 'redirects to the home page' do
        visit '/'

        assert_selector "td#original-url-#{Url.last.id} a", text: 'https://www.google.com/'
      end
    end

    context 'when url is invalid' do
      it 'does not create the short url and shows a message' do
        visit '/'

        fill_in 'url[original_url]', with: ''

        click_on 'Shorten URL'

        assert_selector '#error-div', text: 'URL format is invalid!'
      end

      it 'redirects to the home page' do
        visit '/'

        assert_selector "td#original-url-#{last_record.id} a", text: last_record.original_url
      end
    end
  end

  describe 'visit' do
    it 'redirects the user to the original url' do
      url = Url.create(original_url: 'https://github.com/bhavinNandani')
      visit visit_path(url.short_url)

      expect(page.current_url).to eq url.original_url
    end

    context 'when not found' do
      it 'shows a 404 page' do
        visit visit_path('NOTFOUND')
        # expect page to be a 404

        assert_selector 'h1', text: "The page you were looking for doesn't exist."
      end
    end
  end
end
