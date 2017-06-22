require 'cuba'
require 'cuba/safe'
require 'rack/protection'
require 'json'
require 'date'
require 'time'
require 'sequel'
require 'mail'
require File.join(File.dirname(__FILE__), 'lib/Add_data.rb')
require File.join(File.dirname(__FILE__), 'lib/All_data.rb')
require File.join(File.dirname(__FILE__), 'lib/Avg_level.rb')
require File.join(File.dirname(__FILE__), 'lib/Create_database.rb')
require File.join(File.dirname(__FILE__), 'lib/Edit_data.rb')
require File.join(File.dirname(__FILE__), 'lib/Email_data.rb')
require File.join(File.dirname(__FILE__), 'lib/Remove_data.rb')
require File.join(File.dirname(__FILE__), 'lib/Remove_database.rb')

Cuba.use Rack::Session::Cookie, secret: Random.new_seed.to_s
Cuba.use Rack::Protection
Cuba.use Rack::Protection::RemoteReferrer
Cuba.plugin Cuba::Safe

extend AllData
extend AvgLevel
extend AddData
extend CreateDatabase
extend EditData
extend EmailData
extend RemoveData
extend RemoveDatabase

Cuba.define do
  @version = 'v1'
  on get do
    on root do
      res.redirect("#{@version}/all")
    end

    on "#{@version}/all" do
      run AllData::AllData
    end

    on "#{@version}/avg" do
      run AvgLevel::AvgLevel
    end

    on "#{@version}/add" do
      run AddData::AddData
    end

    on "#{@version}/createdb" do
      run CreateDatabase::CreateDatabase
    end

    on "#{@version}/edit" do
      run EditData::EditData
    end

    on "#{@version}/email" do
      run EmailData::EmailData
    end

    on "#{@version}/rm" do
      run RemoveData::RemoveData
    end

    on "#{@version}/removedb" do
      run RemoveDatabase::RemoveDatabase
    end
  end
end
