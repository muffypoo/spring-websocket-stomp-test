<!--
  Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<!DOCTYPE html>
<html>
<head>
    <title>WebSocket/SockJS/Stomp Echo Sample (Adapted from rstoyanchev's test)</title>
    <style type="text/css">
        #connect-container {
            float: left;
            margin-left: 30%;
            width: 100%;
        }

        #connect-container div {
            padding: 5px;
        }

        #console-container {
            float: left;
            margin-left: 30%;
            width: 40%;
        }

        #console {
            border: 1px solid #CCCCCC;
            border-right-color: #999999;
            border-bottom-color: #999999;
            height: 170px;
            overflow-y: scroll;
            padding: 5px;
            width: 100%;
        }

        #console p {
            padding: 0;
            margin: 0;
        }
    </style>

    <script src="//cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.1/sockjs.min.js"></script>
	<script src="//cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.js"></script>
    <script type="text/javascript">
        var ws = null;
        var url = "/spring-websocket-stomp-test/websocket/";
        var stompClient = null;
        var subscription = null;
        var isDebug = false;
        
        function setConnected(connected) {
            document.getElementById('connect').disabled = connected;
            document.getElementById('disconnect').disabled = !connected;
            document.getElementById('echo').disabled = !connected;
            document.getElementById('ping').disabled = !connected;
        }

        function connect() {
               ws = new SockJS(url);
           	stompClient = Stomp.over(ws);
           	
			var connectCallback = function() {
       			log("Info: connection opened.");
				setConnected(true);
       			stompClient.subscribe("/app/echo", function(data) {
           				if(data) {
            				log("Received: " + data);
              				}
           			}
       			);
       			stompClient.subscribe("/user/queue/echo", function(data) {
           				if(data) {
            				var body = JSON.parse(data.body);
        					log("Self: " + body.value);
           				}
       				}
   				);
       			stompClient.subscribe("/topic/ping", function(data) {
        				if(data) {
            				var body = JSON.parse(data.body);
        					log("Public: " + body.value);
        				}
    				}
   				);
       		};
       		var errorCallback = function(error) {
       			if(error.headers) {
       				log("Error: " + error.headers.message);
       			}
       		};
               
           	if(isDebug) {
            	stompClient.debug = function(str){
                	log("Debug: " + str);
                };
               }

			stompClient.connect({}, connectCallback, errorCallback);
        }

        function disconnect() {
        	if(stompClient != null) {
            	stompClient.disconnect(function() {
                	log("Info: Disconnected.");
                })
        	} else {
	            if (ws != null) {
	                ws.close();
	                ws = null;
	            }
            }
            setConnected(false);
        }

        function echo() {
            if (ws != null) {
                var message = document.getElementById('message').value;
                log('Sent: ' + message);
                if(stompClient != null) {
                	stompClient.send("/app/echo", {}, JSON.stringify({'key':'MYKEY', 'value':message}));
				}
            } else {
                alert('connection not established, please connect.');
            }
        }

        function ping() {
            if (ws != null) {
                var message = document.getElementById('message').value;
                log('Pinging with: ' + message);
                if(stompClient != null) {
                	stompClient.send("/app/ping", {}, JSON.stringify({'key':'MYKEY', 'value':message}));
				}
            } else {
                alert('connection not established, please connect.');
            }
        }

        function log(message) {
            var console = document.getElementById('console');
            var p = document.createElement('p');
            p.style.wordWrap = 'break-word';
            p.appendChild(document.createTextNode(message));
            console.appendChild(p);
            while (console.childNodes.length > 25) {
                console.removeChild(console.firstChild);
            }
            console.scrollTop = console.scrollHeight;
        }
    </script>
</head>
<body>
<noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websockets 
    rely on Javascript being enabled. Please enable
    Javascript and reload this page!</h2></noscript>
<div>
    <div id="connect-container">
        <div>
            <button id="connect" onclick="connect();">Connect</button>
            <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>
        </div>
        <div>
            <textarea id="message" style="width: 350px">Here is a message!</textarea>
        </div>
        <div>
            <button id="echo" onclick="echo();" disabled="disabled">Echo message</button>
            <button id="ping" onclick="ping();" disabled="disabled">Ping everybody</button>
        </div>
    </div>
    <div id="console-container">
        <div id="console"></div>
    </div>
</div>
</body>
</html>
