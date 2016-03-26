#!/usr/bin/env bash

echo 'Bootstrap maven'
./mvnw clean --log-file mvn.log
rm mvn.log

files="static webapp"

wait_server() {
	http_status='000'
	app_status=1
	while [ ${app_status} -ne 0 ] || [ ${http_status} != '200' ] ; do
		sleep 1s
		http_status=$(curl -i -s -o /dev/null -w '%{http_code}' "http://localhost:8080/static.html")
		app_status=$?
#		echo "HTTP: ${http_status}; APP: ${app_status}"
	done
}

app_run="java -jar target/spring-boot-5287-0.0.1-SNAPSHOT.war"
profiles='tomcat-8.0 jetty-9.2 jetty-9.3'
cnt_not_200=0
for profile in ${profiles} ; do
	echo "Check profile: ${profile}"

	echo "... build"
	./mvnw clean package -P${profile} --log-file mvn.log
	rm mvn.log

	echo "... run"
	${app_run} > /dev/null &
	PID=$!
	wait_server

	echo "... test"
	for file in ${files} ; do
		status=$(curl -i -s -o /dev/null -w '%{http_code}' "http://localhost:8080/${file}.html")
		echo "     ${file}: ${status}"
		if [ ${status} != "200" ] ; then
			cnt_not_200=$((cnt_not_200 + 1))
		fi
	done

	echo "... stop"
	kill -9 $PID 2> /dev/null
	sleep 1s
done

exit ${cnt_not_200}
