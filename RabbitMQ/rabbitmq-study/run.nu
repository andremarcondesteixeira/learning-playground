def main [classname: string] {
    javac -classpath ".;amqp-client-5.16.0.jar;slf4j-simple-1.7.36.jar;slf4j-api-1.7.36.jar" -d out ./com/myapp/CompileMeToCompileEverything.java
    java -classpath "out;amqp-client-5.16.0.jar;slf4j-simple-1.7.36.jar;slf4j-api-1.7.36.jar" $classname
}
