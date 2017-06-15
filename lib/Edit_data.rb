
module EditData
  class EditData < Cuba; end
  EditData.define do
    on root, param('database'), param('id'), param('d'), param('t'), param('l') do |database, id, d, t, l|
      DB = Sequel.connect("sqlite://db/#{database}.sqlite3", max_connections: 200)
      data = DB[:data]
      res.headers['Content-Type'] = 'application/json; charset=utf-8'
      data.where(id: id.to_s).update(date: d.to_s, time: t.to_s, level: l.to_s)
      res.write data.all.to_json
    end
  end
end
