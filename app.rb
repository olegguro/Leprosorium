#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@bd = results_as_hush = true
end

#before вызывается каждый раз при перезагрузке любой страницы
before do
	#инициализация БД
	init_db
end

	# вызывается каждый раз при конфигурации приложения
	#когда изменился код и перезагрузилась страница
configure do
	#инициализация БД
	init_db
	#создаем таблицу, если таблица существует
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
	
	#получаем переменную из POST-запроса
	content = params[:content]

	erb "You types #{content}"
end