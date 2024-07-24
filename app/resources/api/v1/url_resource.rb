class Api::V1::UrlResource < JSONAPI::Resource
	attributes :created_at, :original_url
	attribute :url
	attribute :clicks, delegate: :clicks_count

	exclude_links :default

	has_many :clicks # https://github.com/cerebris/jsonapi-resources/issues/1394

	def url
		Rails.application.routes.url_helpers.root_url + @model.short_url
	end

	def self.default_sort
	  [{field: :created_at, direction: :desc}]
	end
end
