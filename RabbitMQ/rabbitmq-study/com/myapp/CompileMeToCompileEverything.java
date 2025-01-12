package com.myapp;

public class CompileMeToCompileEverything {
    public static void main(String[] args) {
        System.out.println(com.myapp.HelloWorld.Send.class.getName());
        System.out.println(com.myapp.HelloWorld.Recv.class.getName());
        System.out.println(com.myapp.WorkQueues.Send.class.getName());
        System.out.println(com.myapp.WorkQueues.Worker.class.getName());
        System.out.println(com.myapp.WorkQueues.WorkerWithoutShutdownHook.class.getName());
    }
}
