
module Api
  class RemoveData < Cuba; end
  DB = Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)
  data = DB[:data]
  RemoveData.define do
    on root, param('d'), param('t'), param('l') do |d, t, l|
      res.headers['Content-Type'] = 'application/json; charset=utf-8'
      data.where(date: d.to_s, time: t.to_s, level: l.to_s).delete
      res.write data.all.to_json
    end
  end
end
