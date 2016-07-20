package org.springframework.samples.websocket.stomp.echo;

import java.util.HashSet;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.samples.websocket.stomp.MyMessage;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class EchoController {
	@Autowired
	private EchoService echoService;
	private static final Logger logger = LoggerFactory.getLogger(EchoController.class);
	private Set<String> subscriberSessions = new HashSet<String>();

	/**
	 * Home page displaying echo.jsp
	 * @return
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		return "echo";
	}
	
	/**
	 * Server-side receiving method for user message sent to /app/echo
	 * which in turn will output a message to /user/queue/echo.
	 *  
	 * @param smha
	 * @param msg
	 * @return
	 */
	@MessageMapping("/echo")
	@SendToUser("/queue/echo")
	public MyMessage receiveEcho(SimpMessageHeaderAccessor smha, MyMessage msg) {
		logger.debug("EchoController.receiveEcho");
		if(subscriberSessions.contains(smha.getSessionId())) {
			msg.setValue(echoService.getMessage(msg.getValue()));
		} else {
			msg.setValue("No subscription, no echo.");
		}
		
		return msg;
	}
	
	/**
	 * Server-side receiving method for user subscription to /app/echo 
	 * which will trigger adding the subscriber session id into the Set.
	 * 
	 * @param smha
	 */
	@SubscribeMapping("/echo")
	public void subscribeEcho(SimpMessageHeaderAccessor smha) {
		logger.debug("EchoController.subscribeEcho");
		subscriberSessions.add(smha.getSessionId());
	}

	/**
	 * Server-side receiving method for user message sent to /app/ping
	 * which in turn will output a message to /topic/ping.
	 *  
	 * @param smha
	 * @param msg
	 * @return
	 */
	@MessageMapping("/ping")
	@SendTo("/topic/ping")
	public MyMessage receivePing(SimpMessageHeaderAccessor smha, MyMessage msg) {
		logger.debug("EchoController.receivePing");
		if(subscriberSessions.contains(smha.getSessionId())) {
			msg.setValue(echoService.getMessage(msg.getValue()));
		} else {
			msg.setValue("No subscription, no echo.");
		}
		
		return msg;
	}

	/**
	 * Server-side receiving method for user subscription to /app/ping
	 * which does not do anything.
	 * 
	 * @param smha
	 */
	@SubscribeMapping("/ping")
	public void subscribePing(SimpMessageHeaderAccessor smha) {
		logger.debug("EchoController.subscribePing");
		//do nothing;
	}
}
