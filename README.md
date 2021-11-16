# Slice Code Challenge

## Description
Pizzabot is a robot that's main task is to deliver a pizza. 
Challenge assumed the map where the bot navigates to be 2-dimensional and 
the goal of the project is to create a path for a bot to reach every input paths and deliver pizza. 
The outcome should be as a string representing movements of a bot on the map.

## Prerequisites

Project was developed using `Xcode 13.1` and `Swift 5.5`. 
Please make sure to have the latest Xcode version. 
You may not be able to open the project if the Xcode version is below 13.1.
The entire project was developed as a MacOS framework so as to make unit-tests instant with almost no delay. 
Since the challenge assumed the production project to be somewhat a command line tool, 
I have decided to create it as a MacOS framework. 

## Running

Since the project was assumed to be a command line application, 
I have created tests that validate the expected behavior. 
For running the project, please open `Pizzabot/PizzabotChallengeTests/EnvironmentTests.swift`. 
The method that asserts the required behavior is `test_startBot_correctlyFollowsMainInputPath`.
It clearly follows the paths on the grid and computes a final string. 
For running the entire test suite, press `Cmd + U`.

## General idea

There are couple of classes that interact with each other:
* _Direction_. Is an enum representing directions or moves a PizzaBot can execute in the environment.
Each move has an associated moveValue computed property that defines a coordinate-wise movement in the range [-1,1]. 
Thus, 1 defines moving upward (north) or right (east) and -1 represents moving down (south) or left (west).
Value 0 defines a drop. Drop is also considerate as a `movement` in this sense

* _Map_. `Map` determines a grid system with bounds.
Since bot can't move itself freely, Map defines a bounds where a bot can or can't move. 
This is an abstract interface that can be implemented by any client and we are not constraining our map to be only 2-dimensional. 
`PizzaMap`, its concrete implementation, has a `mapSize` injected into it for validating moves of a bot on the map.
`validateMove` instance method would assert whether a bot can move and it completes
with an optional error (if move is invalid). A bot can move freely if aforementioned method completes with nil error.

* _Bot_. `Bot` is also a protocol that defines public interfaces for clients to access.
Bot has a single instance method `move` that should indeed call Map's validateMove 
in each movement since map has its own size. `PizzaBot` is an implementation of this 
protocol that closely interacts with a `PizzaMap` for validating its moves. 
`position` property is a public tuple (getter) for asserting or checking the current position of the bot.
   
* _Environment_. `Environment` is again an interface that defines the environment 
where the Bot operates or moves. It has an `initializer that can throw` 
in case of invalid input (will be explained later) and
a startBot() method that can also throw in case of invalid moves. 
`PizzaEnvironment` is an implementation detail of the Environment
 that closely interacts with a Bot and captures each move made by it. 
 Therefore, it has `botMoves` public getter for asserting bot's moves for a specified input string.
 
* _Helpers_. `InputParser` is class that defines static methods 
for validating and parsing the input string specified by the user.
Since the parser is used simply as a validator,
we are not required to instantiate it and it mainly acts as a namespace.
It also defines a custom `ParseError` enum that clearly idenfies 
each error case during parsing strategy.
Parser has two static methods, `parseInputMapSize` for parsing the map size and `parseInputPaths` 
for parsing the paths from the input string. Both of these methods can throw if the provided input is invalid. 

## Input String Validation

First, let's define invalid input strings for the PizzaEnvironment.
```
empty string
x (1, 3) (2, 3)
5x (1, 3) (2, 3)
x5 (1, 3) (2, 3)
5x5 (1 3) (2, 3)
5x5 1, 3) (2, 3)
5x5 (1, 3 (2, 3)
5x5 (1, 3) 2, 3)
5x5 (1, 3) (2, 3
5x5 (1, 5) (2, 3)
and etc
``` 
As we can clearly see, the `InputParser` would definitely throw in those cases.
The only valid strings that can be passed are
```
5x5 (1, 3) (2, 3)
5x5 (1,3)(2,3)
``` 
Therefore, InputParser won't throw any error if the input string matches the above standard.

## Bot Navigation Logic
Since bot has 5 actions (4 movements and a drop action), we can break down `Direction` enum. 
The map is a 2-d grid system and the origin is at (0,0)

* `East` - moves east one cell in X position.
           e.g. moving east from (0,0) results in (1,0). It increments X position by 1.
* `West` - moves west one cell in X position. 
           e.g. moving east from (1,0) results in (0,0). It decrements X position by 1. 
           Moving west in (0,0) results in a failure.
* `North` - moves north one cell in Y position. 
            e.g. moving east from (0,0) results in (0,1). It increments Y position by 1.
* `South` - moves south one cell in Y position. 
            e.g. moving east from (0,1) results in (0,0). It decrements Y position by 1.

We should note that the bot can't move out of map bounds and it will result in the error.
 However, the entire navigation logic eliminates all the errors and this is backed up by tests.

Let's consider a simple scenario of moving from origin to `(2, 3)`.
Input string : `5x5 (2, 3)`.
Bot always moves with regards to X coordinate and then in terms of Y coordinate. 
Therefore, we would end up with the following sequence of moves: east, east, north, north, north, drop.
Consequently, the actions performed by a bot are converted into a string -> `EENNND` 
`Note` - Bot already takes into account map bounds `5x5` 
by the means of a parser that throws if any of the input paths 
is equal to or greater than the map size. 
Thus, it does not move out of map bounds. 
The resultant string for the input string `5x5 (2, 3)` would `always` be the same.

## Results
The main requirement of the challenge was to generate a path string for the input 
```sh 
5x5 (0, 0) (1, 3) (4, 4) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)
``` 
The resultant string that the bot computes is `DENNNDEEENDSSDDWWWWSDEEENDWNDEESSD`. 
