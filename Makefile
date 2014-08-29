build:
	coffee -o ./app/scripts -c ./app/coffee-scripts

build-watch:
	coffee -o ./app/scripts -cw ./app/coffee-scripts

run:
	coffee app.coffee

run-watch:
	nodemon app.coffee