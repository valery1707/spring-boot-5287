Test project for issue [Spring boot #5287](https://github.com/spring-projects/spring-boot/issues/5287).

Same code work different in different embedded application servers:
* Tomcat 8.0: accessible both resources: `/src/main/resources/static` and `/src/main/webapp`
* Jetty 9.2: accessible both resources: `/src/main/resources/static` and `/src/main/webapp`
* Jetty 9.3: accessible only `/src/main/resources/static`, `/src/main/webapp` is not accessible

For test you can run scripts:
* `check_auto.sh` - build all profiles and check status of pages
* `check_manual.sh` - build all profiles and make separate `war`-files and you can try to access files by URL `http://localhost:8080/static.html` and `http://localhost:8080/webapp.html`
