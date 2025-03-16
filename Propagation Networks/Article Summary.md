# Chapter 1: Time for a Revolution

The article introduces General Purpose Propagation, a new programming paradigm that transcends time-bound expression evaluation in order to achieve higher levels of expressiveness.

The key ideas are:

1. Propagating mergeable, partial information, allows propagation to be used for general purpose programming
2. Making the merging mechanism generic offers a new kind of modularity and composability
3. A structure to carry dependencies

## 1.1 Expression Evaluation has been Wonderful

Hardware uses assembly language, which is evaluated by a loop executing atomic instructions sequentially.

Higher level programming languages generalize the concept of instructions by using expressions. The main difference is that expressions can be either atomic or have subexpressions. This approach provides greater expressiveness when compared to assembly.

## 1.2 But we Want More

Efforts are being made to improve programming languages:

- Constraint satisfaction
- Logic programming
- Functional reactive programming

## 1.3 We Want More Freedom from Time

Expression based evaluation imposes an order of evaluation: expressions can only be evaluated after its subexpressions are. This is a time constraint that dictates how the computer must run the program. This is the issue that motivated the 3 approaches mentioned in section 1.2.

## 1.4 Propagation Promises Liberty

All the approaches mentioned in section 1.2 organize the computation as a network where data is propagated and order in time is not imposed. However, they are not compatible with each other.

General purpose propagation generalizes expressions (much like expressions generalize instructions) and can solve all the problems that the 3 approaches mentioned in section 1.2 can while providing greater expressive power.

# Chapter 2: Design Principles

## 2.1 Propagators are Asynchronous, Autonomous and Stateless

Computation is arranged as a network of Propagators connected through Cells.

Propagators are stateless machines that make computations and propagate data to the netowrk through Cells.

Propagators are asynchronous, autonomous and always-on (always ready to perform their respective computations). These properties allow to remove time restrictinos because they allow propagators to always do their computations whenever they want.

Cells are stateful: they store data received from Propagators. They are responsible for maintaining their own internal memory consistent and free from invalid and corrupted states. Global consistency should be an emergent property of the network.

```
propagator x sends to f
propagator y sends to f
cell f
propagator f(x, y) listens to f sends to g, h
cell g
cell h
```