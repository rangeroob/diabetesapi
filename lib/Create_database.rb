module CreateDatabase
  class CreateDatabase < Cuba; end
  CreateDatabase.define do
    on root, param('name') do |name|
      res.headers['Content-Type'] = 'text/html; charset=utf-8'
      FileUtils.mkdir 'db' unless Dir.exist?('db')
      DB = Sequel.connect("sqlite://db/#{name}.sqlite3")
      begin unless File.exist?("#{name}.sqlite3")
              DB.create_table :data do
                primary_key :id
                Number :date
                Number :time
                Number :level
              end
            end
      end
      res.write "Database #{name} created"
    end
  end
end
