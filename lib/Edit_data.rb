
module EditData
  class EditData < Cuba; end
  DB = Sequel.connect('sqlite://db/diabetes.sqlite3', max_connections: 200)
  data = DB[:data]
  EditData.define do
    on root, param('id'), param('d'), param('t'), param('l') do |id, d, t, l|
      res.headers['Content-Type'] = 'application/json; charset=utf-8'
      data.where(id: id.to_s).update(date: d.to_s, time: t.to_s, level: l.to_s)
      res.write data.all.to_json
    end
  end
end
