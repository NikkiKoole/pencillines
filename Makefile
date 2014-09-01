serve:
	python -m SimpleHTTPServer  

# watch for changes in all coffee files referenced beginning at main.coffee, build browserified bundle (with sourcemaps)
watch:
	#watchify -t coffeeify --extension=".coffee" src/main.coffee -o build/bundle.js -d
	node ./node_modules/watchify/bin/cmd.js -t coffeeify --extension=".coffee" source/index.coffee -o build/bundle.js -d


