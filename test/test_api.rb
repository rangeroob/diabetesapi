require 'cuba/test'
require './api.rb'
scope do
  # This file populates a database file within the db folder
  # For demonstration purposes

  FileUtils.mkdir 'db' unless Dir.exist?('db')
  DB = Sequel.connect('sqlite://db/diabetes.sqlite3')

  # create an items table
  unless File.exist?('db/diabetes.sqlite3')
  begin
    DB.create_table :data do
      primary_key :id
      Number :date
      Number :time
      Number :level
    end
  end
  # create a dataset from the items table
  data = DB[:data]
  data.insert(id: 1)
  # time is in military time
  # when manually inserting data using this file follow octal literals for Dates
  data.insert(date: Date.new(2017, 0o4, 15), time: 741, level: 281)
  data.insert(date: Date.new(2017, 0o4, 15), time: 957, level: 146)
  data.insert(date: Date.new(2017, 0o4, 15), time: 1156, level: 208)
  data.insert(date: Date.new(2017, 0o4, 15), time: 1254, level: 187)
  data.insert(date: Date.new(2017, 0o4, 15), time: 1440, level: 304)
  data.insert(date: Date.new(2017, 0o4, 15), time: 1516, level: 277)
  data.insert(date: Date.new(2017, 0o4, 15), time: 1600, level: 210)
  data.insert(date: Date.new(2017, 0o4, 15), time: 1727, level: 88)
  data.insert(date: Date.new(2017, 0o4, 15), time: 1810, level: 68)
  data.insert(date: Date.new(2017, 0o4, 15), time: 2145, level: 108)
  end
  test do
    get '/'
    follow_redirect!
    assert last_response.body

    get 'v1/avg'
    assert_equal '187.7', last_response.body

    get 'v1/all'
    assert_equal '[{"id":1,"date":null,"time":null,"level":null},{"id":2,"date":"2017-04-15","time":741,"level":281},{"id":3,"date":"2017-04-15","time":957,"level":146},{"id":4,"date":"2017-04-15","time":1156,"level":208},{"id":5,"date":"2017-04-15","time":1254,"level":187},{"id":6,"date":"2017-04-15","time":1440,"level":304},{"id":7,"date":"2017-04-15","time":1516,"level":277},{"id":8,"date":"2017-04-15","time":1600,"level":210},{"id":9,"date":"2017-04-15","time":1727,"level":88},{"id":10,"date":"2017-04-15","time":1810,"level":68},{"id":11,"date":"2017-04-15","time":2145,"level":108}]', last_response.body

    post 'v1/add?d=2017-05-04&t=1300&l=90'
    assert '[{"id":1,"date":null,"time":null,"level":null},{"id":2,"date":"2017-04-15","time":741,"level":281},{"id":3,"date":"2017-04-15","time":957,"level":146},{"id":4,"date":"2017-04-15","time":1156,"level":208},{"id":5,"date":"2017-04-15","time":1254,"level":187},{"id":6,"date":"2017-04-15","time":1440,"level":304},{"id":7,"date":"2017-04-15","time":1516,"level":277},{"id":8,"date":"2017-04-15","time":1600,"level":210},{"id":9,"date":"2017-04-15","time":1727,"level":88},{"id":10,"date":"2017-04-15","time":1810,"level":68},{"id":11,"date":"2017-04-15","time":2145,"level":108},{"id":12,"date":"2017-05-04,"time":1300,"level":90}]', last_response.body

    delete 'v1/rm?d=2017-05-04&t=1300&l=90'
    assert_equal '[{"id":1,"date":null,"time":null,"level":null},{"id":2,"date":"2017-04-15","time":741,"level":281},{"id":3,"date":"2017-04-15","time":957,"level":146},{"id":4,"date":"2017-04-15","time":1156,"level":208},{"id":5,"date":"2017-04-15","time":1254,"level":187},{"id":6,"date":"2017-04-15","time":1440,"level":304},{"id":7,"date":"2017-04-15","time":1516,"level":277},{"id":8,"date":"2017-04-15","time":1600,"level":210},{"id":9,"date":"2017-04-15","time":1727,"level":88},{"id":10,"date":"2017-04-15","time":1810,"level":68},{"id":11,"date":"2017-04-15","time":2145,"level":108}]', last_response.body

    post 'v1/edit?id=2&d=2017-04-16&t=800&l=5000'
    assert_equal '[{"id":1,"date":null,"time":null,"level":null},{"id":2,"date":"2017-04-16","time":800,"level":5000},{"id":3,"date":"2017-04-15","time":957,"level":146},{"id":4,"date":"2017-04-15","time":1156,"level":208},{"id":5,"date":"2017-04-15","time":1254,"level":187},{"id":6,"date":"2017-04-15","time":1440,"level":304},{"id":7,"date":"2017-04-15","time":1516,"level":277},{"id":8,"date":"2017-04-15","time":1600,"level":210},{"id":9,"date":"2017-04-15","time":1727,"level":88},{"id":10,"date":"2017-04-15","time":1810,"level":68},{"id":11,"date":"2017-04-15","time":2145,"level":108}]', last_response.body
    # revert modified data
    post 'v1/edit?id=2&d=2017-04-15&t=741&l=281'
    assert_equal '[{"id":1,"date":null,"time":null,"level":null},{"id":2,"date":"2017-04-15","time":741,"level":281},{"id":3,"date":"2017-04-15","time":957,"level":146},{"id":4,"date":"2017-04-15","time":1156,"level":208},{"id":5,"date":"2017-04-15","time":1254,"level":187},{"id":6,"date":"2017-04-15","time":1440,"level":304},{"id":7,"date":"2017-04-15","time":1516,"level":277},{"id":8,"date":"2017-04-15","time":1600,"level":210},{"id":9,"date":"2017-04-15","time":1727,"level":88},{"id":10,"date":"2017-04-15","time":1810,"level":68},{"id":11,"date":"2017-04-15","time":2145,"level":108}]', last_response.body

    post 'v1/email?address=receive.diabetesapi@gmail.com'
    assert_equal 'email sent to receive.diabetesapi@gmail.com', last_response.body

    post 'v1/createdb?name=test'
    assert_equal 'Database test created', last_response.body

    delete 'v1/removedb?name=test'
    assert_equal 'Database test removed', last_response.body
  end
end
