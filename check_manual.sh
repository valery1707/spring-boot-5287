#!/usr/bin/env bash

rm *.war
for profile in 'tomcat-8.0' 'jetty-9.2' 'jetty-9.3' ; do
	echo "Build: ${profile}"
	./mvnw clean package -P${profile} --log-file mvn.log
	cp target/*.war ./${profile}.war
done
rm mvn.log
ls *.war
