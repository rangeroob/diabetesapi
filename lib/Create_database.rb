module CreateDatabase
  class CreateDatabase < Cuba; end
  CreateDatabase.define do
    on root, param('create') do |create|
      res.headers['Content-Type'] = 'text/html; charset=utf-8'
      FileUtils.mkdir 'db' unless Dir.exist?('db')
      DB = Sequel.connect("sqlite://db/#{create}.sqlite3")
      begin unless File.exist?("#{create}.sqlite3")
              DB.create_table :data do
                primary_key :id
                Number :date
                Number :time
                Number :level
              end
            end
    end
      res.write "Database #{create} created"
    end
  end
end
