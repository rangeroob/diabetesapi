
module AvgLevel
  class AvgLevel < Cuba; end
  AvgLevel.define do
    on root, param('database') do |database|
      DB = Sequel.connect("sqlite://db/#{database}.sqlite3", max_connections: 200)
      data = DB[:data]
      res.headers['Content-Type'] = 'application/json; charset=utf-8'
      res.write data.avg(:level).to_json
    end
  end
end
