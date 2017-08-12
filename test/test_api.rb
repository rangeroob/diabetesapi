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
        String :userid
        Number :date
        Number :time
        Number :level
      end
      DB.create_table :users do
        String :userid
        String :email
        String :key
      end
    end
    # create a dataset from the items table
    data = DB.from(:data)
    users = DB.from(:users)
    userid = 'c2155911-2bab-42b7-8a8b-8d38acbb34f1'
    key = '\x97\xCC:\v\xD0\xBFbv|]\xAA.\xFF\xCEN\x10gD\xD2\xDC\x1F|\x8B\xC8\xF8^\x94\xA3\xC9\xD8i\xBE'
    payload = userid.to_s
    encrypted = JWE.encrypt(payload, key, alg: 'dir')
    # time is in military time
    # when manually inserting data using this file follow octal literals for Dates
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 741, level: 281)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 957, level: 146)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1156, level: 208)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1254, level: 187)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1440, level: 304)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1516, level: 277)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1600, level: 210)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1727, level: 88)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 1810, level: 68)
    data.insert(userid: userid, date: Date.new(2017, 0o4, 15), time: 2145, level: 108)
    users.insert(userid: userid, email: 'recieve.diabetesapi@gmail.com', key: encrypted)
  end
  test do
    post 'v1/signup?email=recieve.diabetesapi@gmail.com'
    assert_equal 'signed up recieve.diabetesapi@gmail.com', last_response.body

    get '/'
    follow_redirect!
    assert last_response.body

    get 'v1/avg?key=eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4R0NNIn0..1qFSBAuWaSqvuBy9.rftrkz_3TSgfBsy0qz3fxeaAZIu7KmuJHlC1TScZaq9Cpltv.SWrhaW3SKKrYq5OGNn4pYQ'
    assert_equal '187.7', last_response.body

    get 'v1/all?key=eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4R0NNIn0..1qFSBAuWaSqvuBy9.rftrkz_3TSgfBsy0qz3fxeaAZIu7KmuJHlC1TScZaq9Cpltv.SWrhaW3SKKrYq5OGNn4pYQ'
    assert_equal '[{"id":1,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":741,"level":281},{"id":2,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":957,"level":146},{"id":3,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1156,"level":208},{"id":4,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1254,"level":187},{"id":5,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1440,"level":304},{"id":6,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1516,"level":277},{"id":7,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1600,"level":210},{"id":8,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1727,"level":88},{"id":9,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1810,"level":68},{"id":10,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":2145,"level":108}]', last_response.body

    post 'v1/add?key=eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4R0NNIn0..1qFSBAuWaSqvuBy9.rftrkz_3TSgfBsy0qz3fxeaAZIu7KmuJHlC1TScZaq9Cpltv.SWrhaW3SKKrYq5OGNn4pYQ&d=2017-05-04&t=1300&l=90'
    assert_equal '[{"id":1,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":741,"level":281},{"id":2,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":957,"level":146},{"id":3,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1156,"level":208},{"id":4,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1254,"level":187},{"id":5,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1440,"level":304},{"id":6,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1516,"level":277},{"id":7,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1600,"level":210},{"id":8,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1727,"level":88},{"id":9,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1810,"level":68},{"id":10,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":2145,"level":108},{"id":11,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-05-04","time":1300,"level":90}]', last_response.body

    delete 'v1/rm?key=eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4R0NNIn0..1qFSBAuWaSqvuBy9.rftrkz_3TSgfBsy0qz3fxeaAZIu7KmuJHlC1TScZaq9Cpltv.SWrhaW3SKKrYq5OGNn4pYQ&d=2017-05-04&t=1300&l=90'
    assert_equal '[{"id":1,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":741,"level":281},{"id":2,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":957,"level":146},{"id":3,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1156,"level":208},{"id":4,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1254,"level":187},{"id":5,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1440,"level":304},{"id":6,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1516,"level":277},{"id":7,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1600,"level":210},{"id":8,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1727,"level":88},{"id":9,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1810,"level":68},{"id":10,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":2145,"level":108}]', last_response.body

    post 'v1/edit?key=eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4R0NNIn0..1qFSBAuWaSqvuBy9.rftrkz_3TSgfBsy0qz3fxeaAZIu7KmuJHlC1TScZaq9Cpltv.SWrhaW3SKKrYq5OGNn4pYQ&id=2&d=2017-04-16&t=800&l=5000'
    assert_equal '[{"id":1,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":741,"level":281},{"id":2,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-16","time":800,"level":5000},{"id":3,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1156,"level":208},{"id":4,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1254,"level":187},{"id":5,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1440,"level":304},{"id":6,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1516,"level":277},{"id":7,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1600,"level":210},{"id":8,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1727,"level":88},{"id":9,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1810,"level":68},{"id":10,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":2145,"level":108}]', last_response.body
    # revert modified data
    post 'v1/edit?key=eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4R0NNIn0..1qFSBAuWaSqvuBy9.rftrkz_3TSgfBsy0qz3fxeaAZIu7KmuJHlC1TScZaq9Cpltv.SWrhaW3SKKrYq5OGNn4pYQ&id=2&d=2017-04-15&t=957&l=146'
    assert_equal '[{"id":1,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":741,"level":281},{"id":2,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":957,"level":146},{"id":3,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1156,"level":208},{"id":4,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1254,"level":187},{"id":5,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1440,"level":304},{"id":6,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1516,"level":277},{"id":7,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1600,"level":210},{"id":8,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1727,"level":88},{"id":9,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":1810,"level":68},{"id":10,"userid":"c2155911-2bab-42b7-8a8b-8d38acbb34f1","date":"2017-04-15","time":2145,"level":108}]', last_response.body

    post 'v1/email?address=receive.diabetesapi@gmail.com&key=eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4R0NNIn0..1qFSBAuWaSqvuBy9.rftrkz_3TSgfBsy0qz3fxeaAZIu7KmuJHlC1TScZaq9Cpltv.SWrhaW3SKKrYq5OGNn4pYQ'
    assert_equal 'email sent to receive.diabetesapi@gmail.com', last_response.body

    post 'v1/createdb?name=test'
    assert_equal 'Database test created', last_response.body

    delete 'v1/removedb?name=test'
    assert_equal 'Database test removed', last_response.body
  end
end
