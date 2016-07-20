
if [ -z "$WILDFLY_HOME" ]; then
    echo -e "\n\nPlease set WILDFLY_HOME\n\n"
    exit 1
fi

mvn -DskipTests clean package

rm -rf $WILDFLY_HOME/standalone/deployments/spring-websocketstomp--test*

cp target/spring-websocket-stomp-test.war $WILDFLY_HOME/standalone/deployments/

$WILDFLY_HOME/bin/standalone.sh
