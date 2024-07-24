# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do
    let!(:url) { create(:url) }

    it 'validates url_id is valid' do
      click = url.clicks.new(platform: 'macOS', browser: 'Chrome')

      expect(click.url_id).to eq(url.id)
    end

    it 'validates browser is not null' do
      click = url.clicks.new(platform: 'macOS', browser: nil)

      expect { click.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Browser can't be blank")
    end

    it 'validates platform is not null' do
      click = url.clicks.new(platform: nil, browser: 'Chrome')

      expect { click.save! }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Platform can't be blank")
    end
  end
end
