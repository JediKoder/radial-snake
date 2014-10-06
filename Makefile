font-data-parse:
	coffee -e 'require("./helpers/font_data_parser").xmlsToJsons "./resources/assets/fonts", (err) -> throw err if err'

build:
	coffee -o ./resources/scripts -c ./resources/coffee-scripts

build-watch:
	coffee -o ./resources/scripts -cw ./resources/coffee-scripts

run:
	coffee server.coffee

run-watch:
	nodemon server.coffee