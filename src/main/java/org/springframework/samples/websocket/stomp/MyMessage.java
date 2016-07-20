/**
 * @author Ken Kum
 * @since 18 Jul 2016
 * 
 */
package org.springframework.samples.websocket.stomp;

import java.io.Serializable;

/**
 * @author Ken Kum
 *
 */
public class MyMessage implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = -319843114850898191L;
	private String key;
	private String value;
	/**
	 * 
	 */
	public MyMessage() {
		// TODO Auto-generated constructor stub
	}
	/**
	 * 
	 */
	public MyMessage(String key, String value) {
		this.key = key;
		this.value = value;
	}
	
	/**
	 * @return the key
	 */
	public String getKey() {
		return key;
	}
	/**
	 * @param key the key to set
	 */
	public void setKey(String key) {
		this.key = key;
	}
	/**
	 * @return the value
	 */
	public String getValue() {
		return value;
	}
	/**
	 * @param value the value to set
	 */
	public void setValue(String value) {
		this.value = value;
	}
}
