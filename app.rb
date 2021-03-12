
require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

get('/') do
    slim(:index)
end

get('/admin') do
  slim(:admin)
end


get('/login') do
    slim(:login)
 end

get('/register') do
    slim(:register)
end

get('/konto') do
  slim(:konto)
end

get('/kontakt') do
  slim(:kontakt)
end

get('/about') do
  slim(:about)
end

get('/galleri') do
  slim(:galleri)
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
      if username == "admin" 
        session[:id] = id
        redirect('/admin')
      else 
      session[:id] = id
      redirect('/konto')
      end
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

  post('/handla/new') do 
    paket = params[:paket]
    id = session[:id].to_i
    db = SQLite3::Database.new('db/databas.db')
    db.execute("INSERT INTO paket (paketnamn,paketid) VALUES (?,?)",paketnamn,paketid)
    redirect('/admin')
  end 
  
  
  post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]
    if (password == password_confirm)
      password_digest = BCrypt::Password.create(password)
      db = SQLite3::Database.new('databas/databas.db')
      db.execute("INSERT INTO users (username,pwdigest) VALUES (?,?)",username,password_digest)
      redirect('/konto')
      "Tack för att du registrerade dig"
    else 
      "Lösenorden matchade inte"
    end 
  end 

  post('/konto') do 
    username = params[:username]
    namn = params[:namn]
    gata = params[:adress]
    telefon = params[:telefon]
    postnr = params[:postnr]
    ort = params[:ort]
    email = params[:email]
    db = SQLite3::Database.new('databas/databas.db')
    db.results_as_hash = true 
   # result = db.execute("SELECT * FROM users WHERE username = ?", username).first
    #pwdigest = result["pwdigest"]
   #id = result["id"]
   
  end 

