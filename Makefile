build:
	coffee -o ./resources/scripts -c ./resources/coffee-scripts

build-watch:
	coffee -o ./resources/scripts -cw ./resources/coffee-scripts

run:
	coffee server.coffee

run-watch:
	nodemon server.coffee