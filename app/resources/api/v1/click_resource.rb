class Api::V1::ClickResource < JSONAPI::Resource
	attributes :platform, :browser

	exclude_links :default

	has_one :url, always_include_linkage_data: true
end
