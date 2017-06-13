
module AllData
  DB = Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)
  data = DB[:data]
  class AllData < Cuba; end
  AllData.define do
    on root do
      res.headers['Content-Type'] = 'application/json; charset=utf-8'
      res.write data.all.to_json
    end
  end
end
