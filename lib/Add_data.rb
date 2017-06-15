module AddData
  class AddData < Cuba; end
  AddData.define do
    on root, param('database'), param('d'), param('t'), param('l') do |database, d, t, l|
      DB = Sequel.connect("sqlite://db/#{database}.sqlite3", max_connections: 200)
      data = DB[:data]
      res.headers['Content-Type'] = 'application/json; charset=utf-8'
      data.insert(date: d.to_s, time: t.to_s, level: l.to_s)
      res.write data.all.to_json
    end
  end
end
