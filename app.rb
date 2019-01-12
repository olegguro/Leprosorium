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
	created_date DATE,
	content TEXT);' 
end
	
get '/' do
	#выбираем список постов из ДБ
	@results = @db.execute 'select * from Posts order by id desc;'	

	erb :index			
end

get '/new' do
	erb :new
end

post '/new' do
	
	#получаем переменную из POST-запроса
	content = params[:content]
	if content.length <= 0
		@error = 'Type post text'
		return erb :new
	end
	#сохранение данных в БД
	@db.execute 'insert into Posts (content, created_date) values (?, datetime())',
	[content]

	erb "You types #{content}"
end