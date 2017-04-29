require 'cuba'
require 'rack/protection'
require 'json'
require 'date'
require 'time'
require 'sequel'
# If you need extra protection.
 Cuba.use Rack::Session::Cookie, :secret => Random.new_seed.to_s
 Cuba.use Rack::Protection
 Cuba.use Rack::Protection::RemoteReferrer
DB = Sequel.connect('sqlite://db/diabetes.sqlite3', :max_connections=>200)

   data = DB[:data]
# To launch just type: 'rackup' in your console
Cuba.define do
  on get do

   on "all" do
     res.headers["Conent-Type"] = "application/json; charset=utf-8"
     res.write data.all.to_json
  end

  on "avg" do 
    res.headers["Conent-Type"] = "application/json; charset=utf-8"
    res.write data.avg(:level).to_json
  end

  on "level", param("a") do |add|
    res.headers["Conent-Type"] = "application/json; charset=utf-8"
    data.insert(:level => "#{add}") 
    res.write "#{add}".to_json
    end
end
end