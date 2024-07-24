# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include JSONAPI::ActsAsResourceController

  # rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def not_found
    # raise ActionController::RoutingError.new('Not Found')
    render file: Rails.root.join('public/404'), layout: false, status: :not_found
    # send_file Rails.root.join('public/404.html'), :type => 'text/html; charset=utf-8', :status => 404
  end
end
