# frozen_string_literal: true

class Click < ApplicationRecord
  belongs_to :url

  validates_presence_of :browser
  validates_presence_of :platform

  after_save :increase_count
  after_destroy :decrease_count

  scope :from_this_month, lambda {
    where('clicks.created_at > ? AND clicks.created_at < ?', Time.now.beginning_of_month,
          Time.now.end_of_month)
  }

  scope :latest, -> { order(created_at: :desc) }

  def json_api_attrs (options = {})
    attrs = []
    attrs += %w(platform browser)
    attrs
  end

  def json_api_relations (options = {})
    %w(url)
  end

  private

  def increase_count
    url.update(clicks_count: url.clicks_count + 1)
  end

  def decrease_count
    click_count = url.clicks_count
    return unless click_count.positive?

    url.update(clicks_count: click_count - 1)
  end
end
