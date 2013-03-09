Bundler.require :web

%w{radio_client app}.each do |file|
  require_relative "./web/#{file}"
end
