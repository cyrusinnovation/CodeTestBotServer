# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

levels = Level.create(['Junior', 'Mid', 'Senior', 'Tech Lead'].collect_concat {|l| {text: l}})
languages = Language.create([{name: 'Java'}, {name: 'Ruby'}, {name: 'Scala'}, {name: 'Python'}, {name: 'Clojure'}])
roles = Role.create([{name: 'Assessor'}, {name: 'Recruiter'}, {name: 'Administrator'}])
