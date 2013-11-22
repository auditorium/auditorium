echo 'Drop database'
rake db:drop
echo 'Create empty databse'
rake db:create
echo 'Insert database from $1'
mysql -u auditorium -p auditorium_next < $1
echo 'Migrate database schema'
rake db:migrate
echo 'Run migration skript to migrate to v2.0'
rake db:convert:v2 --trace
