require 'rubygems'
require 'activerecord'
require 'shoulda'
require 'matchy'
require 'logger'

ActiveRecord::Base.configurations = {'sqlite3' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('sqlite3')

ActiveRecord::Base.logger = Logger.new(STDERR)
ActiveRecord::Base.logger.level = Logger::WARN

ActiveRecord::Schema.define(:version => 0) do
  create_table :users do |t|
    t.string  :first_name, :default => ''
    t.string  :last_name, :default => ''
  end

  create_table :articles do |t|
    t.string  :title, :default => ''
    t.integer :user_id
  end
end

class User < ActiveRecord::Base
  has_many :articles
end

class Article < ActiveRecord::Base
  belongs_to :user
end