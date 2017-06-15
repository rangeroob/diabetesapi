
module AllData
  class AllData < Cuba; end
  AllData.define do
    on root, param('database') do |database|
      DB = Sequel.connect("sqlite://db/#{database}.sqlite3", max_connections: 200)
      data = DB[:data]
      res.headers['Content-Type'] = 'application/json; charset=utf-8'
      res.write data.all.to_json
    end
  end
end
