# frozen_string_literal: true

require 'net/http'

class Url < ApplicationRecord
  # constant
  SLUG_FORMAT = %r{^(https?://)?([\da-z.-]+)\.([a-z.]{2,6})([/\w# .-]*)*/?$}.freeze

  # association
  has_many :clicks, dependent: :delete_all

  # callbacks
  before_create :create_unique_short_url

  # validation
  validates :original_url, presence: { message: "URL can't be blank!" },
                           format: {
                             with: Regexp.new("\\A#{SLUG_FORMAT.source}\\z"),
                             message: 'URL format is invalid!'
                           }

  # scope
  scope :latest, -> { order(created_at: :desc) }

  def formatted_created_at
    created_at.strftime('%b %d,%Y')
  end

  private

  def create_unique_short_url
    loop do
      self.short_url = random_string
      break unless Url.exists?(short_url: short_url)
    end
  end

  def random_string
    (0...5).map { rand(65..90).chr }.join # 7893600 unique string create
  end
end
