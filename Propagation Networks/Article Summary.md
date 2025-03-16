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

## 2.2 We Simulate the Network until Quiescence

The network will be computed until there is nothing more to do.

## 2.3 Cells Accumulate Information

Cells progressively accumulate information about a value, instead of just storing the value itself. Note that this does not mean "storing multiple values", but "accumulating partial information until the value is known".

The information can be incomplete and can come from multiple sources and directions in the network. The cell can ask its propagators to search for more information about the value until the value is known.

### 2.3.1 Why don't cells store values?

The article gives one example why: It would force the language designer to make an arbitrary choice about what to do when a propagator tries to store a value in a non-empty cell that is different from the current value, and this choice could specialize the system to some purpose that might be incompatible with the way other propagation systems work.

### 2.3.2 Because trying to store values causes trouble

3 things could be done if the cell already had a value when a propagator tries do fill in another value:

1. Ignore the new value: This is bad because it would make constraint systems not work.
2. Overwrite the value in the cell: This is bad because it can cause infinite loops
3. Forbid it. Throw an error: This is bad because it would just delay the problem of needing to choose between options 1 or 2.

Solving this with an equality test would also be an arbitrary decision and be incompatible with constraint satisfaction by domain reduction and functional reactive programming.

### 2.3.3 And accumulating information is better

A better approach is to make cells accumulate every information they know about a value, never forgetting this information or replacing it. This would solve the problems stated in the previous section and is crucial for liberating us from the constraints of time.

This idea makes propagation a core mechanism that can be separated from other concerns such as equality and truth maintenance systems, which could be added later, having a common propagation language, which would allow them to interoperate, which would lead to a higher level of expressiveness.

# Chapter 3: Core Implementation
