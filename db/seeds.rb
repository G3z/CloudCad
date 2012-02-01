# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
#

# Cro gli utenti
fabio = User.create(
    :email => "fabio.trezzi@gmail",
    :password => "qweqwe",
    :name => "Fabio",
    :surname => "Trezzi")

User.create(
    :email => "giacomo.trezzi@gmail",
    :password => "qweqwe",
    :name => "Giacomo",
    :surname => "Trezzi")

# Progetto di prova
Project.create(
    :name => "Hello world!",
    :user_id => fabio
)


