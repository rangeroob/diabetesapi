module AddData
  DB = Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)
  data = DB[:data]
  class AddData < Cuba; end
  AddData.define do
    on root, param('d'), param('t'), param('l') do |d, t, l|
      res.headers['Content-Type'] = 'application/json; charset=utf-8'
      data.insert(date: d.to_s, time: t.to_s, level: l.to_s)
      res.write data.all.to_json
    end
  end
end
