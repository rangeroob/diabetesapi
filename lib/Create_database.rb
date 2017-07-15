module CreateDatabase
  class CreateDatabase < Cuba; end
  CreateDatabase.define do
    on root, param('name') do |name|
      res.headers['Content-Type'] = 'text/html; charset=utf-8'
      FileUtils.mkdir 'db' unless Dir.exist?('db')
      if !File.exist?("db/#{name}.sqlite3")
        DB = Sequel.connect("sqlite://db/#{name}.sqlite3")
        begin
          DB.create_table :data do
            primary_key :id
            Number :date
            Number :time
            Number :level
          end
        end
        res.write "Database #{name} created"
      else
        res.write "Database #{name} already exists"
      end
    end
  end
end
