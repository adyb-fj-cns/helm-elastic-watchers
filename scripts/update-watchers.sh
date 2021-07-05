#!/bin/sh
if [[ -f ".env" ]]; then
    echo "Using local environment variables in .env"
	source .env
fi
FLAGS="-k -s"

cd $JSON_PATH > /dev/null

for FILE in ./**/*
do
	NAME=$ENVIRONMENT-$(echo $FILE | sed 's/\.\///g;s/.json//g;s/\//-/g')
	WATCHER_URL=$URL/_watcher/watch/$NAME

	echo "Updating $NAME watcher"

	curl \
		-X POST \
		--user "$ELASTIC_USER:$ELASTIC_PASSWORD" \
		-H "content-type: application/json" \
		-H "accept: application/json" \
		--data-binary "@$FILE" \
		$FLAGS \
		-k $WATCHER_URL \
		| jq .
done

