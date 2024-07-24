# frozen_string_literal: true

class UrlsController < ApplicationController
  before_action :set_url, only: %i[show visit]

  def index
    # recent 10 short urls
    @url = Url.new
    @urls = Url.latest.limit(10)
  end

  def create
    url = Url.new(url_params)

    if url.save
      redirect_to(urls_path, notice: 'Url was successfully created.')
    else
      redirect_to(urls_path, notice: url.errors.messages.values.join("\n"))
    end
  end

  def show
    # implement queries
    clicks = @url.clicks.from_this_month

    # @daily_clicks = [
    #   ['1', 13],
    #   ['2', 2],
    #   ['3', 1],
    #   ['4', 7],
    #   ['5', 20],
    #   ['6', 18],
    #   ['7', 10],
    #   ['8', 20],
    #   ['9', 15],
    #   ['10', 5]
    # ]

    @daily_clicks = []
    day_by_clicks = clicks.order('DATE(created_at)').group('DATE(created_at)').count

    Date.today.at_beginning_of_month.upto(Date.today) do |d|
      @daily_clicks << [d.strftime('%-d'), day_by_clicks[d].to_i]
    end

    # @browsers_clicks = [
    #   ['IE', 13],
    #   ['Firefox', 22],
    #   ['Chrome', 17],
    #   ['Safari', 7]
    # ]
    @browsers_clicks = custom_group_by(clicks, 'browser')

    # @platform_clicks = [
    #   ['Windows', 13],
    #   ['macOS', 22],
    #   ['Ubuntu', 17],
    #   ['Other', 7]
    # ]
    @platform_clicks = custom_group_by(clicks, 'platform')
    # clicks.order(:browser).group(:browser).count.map { |x, y| [x, y] }
  end

  def visit
    browser = Browser.new(request.env['HTTP_USER_AGENT'])

    @url.clicks.create(browser: browser.name, platform: browser.platform.name)

    redirect_to @url.original_url
  end

  private

  def url_params
    params.require(:url).permit(:original_url)
  end

  def set_url
    @url = Url.find_by_short_url(params[:short_url]) or not_found
  end

  def custom_group_by(clicks, field)
    clicks.order(field.to_sym).group(field.to_sym).count.map { |x, y| [x, y] }
  end
end
