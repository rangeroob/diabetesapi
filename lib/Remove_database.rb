
module RemoveDatabase
  class RemoveDatabase < Cuba; end
  RemoveDatabase.define do
    on root, param('name') do |name|
      res.headers['Content-Type'] = 'text/html; charset=utf-8'
      if File.exist?("db/#{name}.sqlite3")
        FileUtils.remove_entry_secure("db/#{name}.sqlite3")
        res.write "Database #{name} removed"
      else
        res.write "Error Database #{name} doesn't exist"
      end
    end
  end
end
