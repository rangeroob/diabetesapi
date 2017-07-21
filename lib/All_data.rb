
module AllData
  class AllData < Cuba; end
  DB = Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)
  data = DB[:data]
  AllData.define do
    on root do
      res.headers['Content-Type'] = 'application/json; charset=utf-8'
      res.write data.all.to_json
    end
  end
end
