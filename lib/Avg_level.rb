
module Api
  class AvgLevel < Cuba; end
  DB = Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)
  data = DB[:data]
  AvgLevel.define do
    on root do
      res.headers['Content-Type'] = 'application/json; charset=utf-8'
      res.write data.avg(:level).to_json
    end
  end
end
