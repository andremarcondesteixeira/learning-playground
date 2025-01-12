# How to run RabbitMQ

The port 15672 refers to the management plugin, which can be accessed through the browser to manage RabbitMQ

1. `docker build -t my-rabbit:1 .`
2. `docker run -d --hostname my-rabbit -p 5672:5672 -p 15672:15672 my-rabbit:1`

# How to compile manually:

The following command will put the class files in the "out" folder

`javac -classpath ".;amqp-client-5.16.0.jar;slf4j-simple-1.7.36.jar;slf4j-api-1.7.36.jar" -d out ./com/myapp/CompileMeToCompileEverything.java`

# How to run manually:

Put the jars and the output folder in the classpath and run the class using `java`

`java -classpath "out;amqp-client-5.16.0.jar;slf4j-simple-1.7.36.jar;slf4j-api-1.7.36.jar" com.myapp.com.myapp.HelloWorld.Send`

# Scripted compile and run (NuShell required)

Use "run.nu" passing the classname as argument:

`nu ./run.nu com.myapp.WorkQueues.Worker`
