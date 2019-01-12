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
	content TEXT)' 

	@db.execute 'Create table if not exists Comments
	( 
	id integer primary key autoincrement,
	created_date DATE,
	content TEXT,
	post_id integer)' 
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
	@db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

	#перенаправление на гл. страницу
	redirect to '/'
end

	#ввывод информации о посте
get '/details/:post_id' do
	
	#получеам перемунную из url
	post_id = params[:post_id]

	#получаем список постов (у нас будут только один пост)
	results = @db.execute 'select * from Posts where id = ?;', [post_id]

	#выбираем этот один пост в переменную
	@row = results[0]

	#выбираем комментарии для нашего поста
	@comments = @db.execute 'select * from Comments where post_id = ? order by id', [post_id]

	#возвращаем представление details.erb
	erb :details
end

#обработчик post-запроса /details
post '/details/:post_id' do
	#получеам перемунную из url
	post_id = params[:post_id]

	#получаем переменную из POST-запроса
	content = params[:content]

	#сохранение данных в БД
	@db.execute 'insert into Comments 
	(
	content, created_date, post_id
	) 
	values 
	(
	?, datetime(), ?
	)', [content, post_id]


	#перенаправление на страницу поста
	redirect to ('/details/' + post_id)
end