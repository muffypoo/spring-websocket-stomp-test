## Overview

Demonstrates Spring WebSocket and SockJS/Stomp support in Spring Framework 4.3.

This example is essentially a stripped down version of `rstoyanchev/spring-websocket-test`. Spring is configured mostly using XML and certain annotations such as `@Autowired` for this package, instead of a Java-only setup. 

### Jetty 9

The easiest way to run on Jetty 9.1.1 is `mvn jetty:run`.

Open a browser and go to <http://localhost:8080/spring-websocket-stomp-test/>
