parse-font:
	node -e "require(\"./helpers/font_parser\").xmlsToJsons(\"./resources/assets/fonts\", err => { if (err) throw err })"

run:
	node server.js

run-watch:
	nodemon server.js