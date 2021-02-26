
require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

get('/') do
    slim(:index)
end

get('/login') do
    slim(:login)
 end

get('/register') do
    slim(:register)
end

post('/login') do 
    username = params[:username]
    password = params[:password]
    db = SQLite3::Database.new('databas/databas.db')
    db.results_as_hash = true 
    result = db.execute("SELECT * FROM users WHERE username = ?", username).first
    pwdigest = result["pwdigest"]
    id = result["id"]
  
    if BCrypt::Password.new(pwdigest) == password
      session[:id] = id
      redirect('/')
    else 
      "FEL LÖSEN!"
    end 
  end 
  
  get('/handla') do 
    id = session[:id].to_i
    db = SQLite3::Database.new('databas/databas.db')
    db.results_as_hash = true 
    result = db.execute("SELECT * FROM  WHERE paket_id = ?", id)
    slim(:"/handla",locals:{paket:result})
  end 
  
  post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]
    if (password == password_confirm)
      password_digest = BCrypt::Password.create(password)
      db = SQLite3::Database.new('databas/databas.db')
      db.execute("INSERT INTO users (username,pwdigest) VALUES (?,?)",username,password_digest)
      redirect('/')
    else 
      "Lösenorden matchade inte"
    end 
  end 