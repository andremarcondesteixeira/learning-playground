package com.myapp.HelloWorld;

import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.Channel;

import java.nio.charset.StandardCharsets;

public class Send {
    private static final String QUEUE_NAME = "hello";

    public static void main (String[] args) throws Exception {
        var factory = new ConnectionFactory();
        factory.setHost("localhost");
        try (
            Connection connection = factory.newConnection();
            Channel channel = connection.createChannel()
        ) {
            channel.queueDeclare(QUEUE_NAME, false, false, false, null);
            String message = "Hello World!";
            var exchangeName = "";
            channel.basicPublish(exchangeName, QUEUE_NAME, null, message.getBytes(StandardCharsets.UTF_8));
            System.out.println(" [x] Sent '" + message + "'");
        }
    }
}
