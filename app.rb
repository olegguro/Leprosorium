#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@bd = results_as_hush = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'Create table if not exists Posts
	( 
	id integer primary key autoincrement,
	created_date, DATE,
	content, TEXT);' 
end
	
get '/' do
	erb "Hello!"			
end

get '/new' do
	erb :new
end

post '/new' do
	

	content = params[:content]

	erb "You types #{content}"
end