#!/bin/bash

if [ ! -f "/opt/gitblit-data/gitblit.properties" ]; then
	mv /tmp/gitblit-data/* /opt/gitblit-data
fi

cd /opt/gitblit
java -server -Xmx1024M -Djava.awt.headless=true -jar /opt/gitblit/gitblit.jar --baseFolder /opt/gitblit-data

