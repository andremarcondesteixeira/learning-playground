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

Propagators make computations and propagate data to the netowrk through Cells.

Cells store data received from Propagators.

