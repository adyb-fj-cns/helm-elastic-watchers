#!/bin/sh
cd $JSON_PATH > /dev/null

for FILE in ./**/*.json
do
	NAME=$ENVIRONMENT-$(echo $FILE | sed 's/\.\///g;s/.json//g;s/\//-/g');
	WATCHER_URL=$ELASTIC_URL/_watcher/watch/$NAME;

	echo "Updating $WATCHER_URL for $NAME watcher"
    if [ "$DEBUG" = "true" ] ; then
        cat $FILE
    fi

    curl \
        -X POST \
        --user "$ELASTIC_USER:$ELASTIC_PASSWORD" \
        -H "content-type: application/json" \
        -H "accept: application/json" \
        --data-binary @$FILE \
        $FLAGS \
        -k $WATCHER_URL

done
