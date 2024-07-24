# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Url, type: :model do
  subject(:url) { create(:url) }

  describe 'validations' do
    it 'validates original URL is a valid URL' do
      url_valid = Url.create(original_url: 'https://fullstacklabs.notion.site/Ruby-on-Rails-Coding-Challenge-5d9c09b5edb44fb1bec3aea5c7eb7590')
      expect(url_valid).to be_valid
    end

    it 'validates original URL' do
      url_not_valid = Url.create(original_url: 'NOThttps://fullstacklabs.notion.site/Ruby-on-Rails-Coding-Challenge-5d9c09b5edb44fb1bec3aea5c7eb7590')
      expect(url_not_valid).not_to be_valid
    end

    it 'validates original URL with string' do
      url_not_valid = Url.create(original_url: 'I am Bhavin')
      expect(url_not_valid).not_to be_valid
    end

    it 'validates short URL is present' do
      expect(url.short_url).to be_truthy
    end

    it 'validates short URL length 5' do
      expect(url.short_url.length).to be(5)
    end

    it 'validates short URL generate only upper case letters' do
      expect(url.short_url).to match(/([A-Z]{5})/)
    end

    it 'validates short URL NOT generated special characters' do
      expect(url.short_url).not_to match(/\W{5}/)
    end

    it 'validates short URL no whitespace' do
      expect(url.short_url).not_to match(/\s{5}/)
    end

    it 'validates short URL unique' do
      expect(Url.count).to eq(Url.pluck(:short_url).uniq.count)
    end

    it 'validates short URL is not actual URL' do
      expect(url.short_url).not_to match(%r{^(https?://)})
    end
  end
end
