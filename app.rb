
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