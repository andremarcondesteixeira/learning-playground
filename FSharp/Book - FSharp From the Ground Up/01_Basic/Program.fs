open System

// For more information see https://aka.ms/fsharp-console-apps


// --------------------------------------
// COMMAND LINE ARGUMENTS ---------------
// --------------------------------------
let commandLineArgs = Environment.GetCommandLineArgs()
for arg in commandLineArgs do
    printfn $"arg = {arg}"



// --------------------------------------
// MUTABLE PERSON -----------------------
// --------------------------------------
let mutable person = String.Empty

if commandLineArgs.Length > 1 then
    person <- commandLineArgs.[1]
else
    Console.WriteLine("What's your name, motherfucker?")
    person <- Console.ReadLine()

printfn $"Hello, {person}"



// --------------------------------------
// NOT MUTABLE PERSON IS BETTER ---------
// --------------------------------------
let notMutablePerson =
    if commandLineArgs.Length > 1 then
        commandLineArgs.[1]
    else
        Console.WriteLine("What's your name, bitch?")
        Console.ReadLine()
printfn $"Hello, {notMutablePerson}"



// --------------------------------------
// INDEXED FOR LOOPS --------------------
// --------------------------------------
for i in 1..commandLineArgs.Length - 1 do
    printfn $"Hello, {commandLineArgs.[i]}!"



// --------------------------------------
// ITERATOR BASED FOR LOOPS ARE BETTER --
// --------------------------------------
for person in commandLineArgs do
    printfn $"Hello, {person}!"



// --------------------------------------
// DOING LOOPS USING Array.iter ---------
// --------------------------------------
let sayHello person =
    printfn $"Array.iter sends you hello, {person}!"

Array.iter sayHello commandLineArgs
// Array.iter is a "Higher Order Function", i.e, it is a function that receives another function as an argument



// --------------------------------------
// NOW USING FORWARD PIPING -------------
// --------------------------------------
commandLineArgs |> Array.iter sayHello



// --------------------------------------
// AND NOW USING Array.filter -----------
// --------------------------------------
let isValidPerson person =
    not(String.IsNullOrWhiteSpace person)

let isValidPerson_betterVersion person =
    String.IsNullOrWhiteSpace person |> not

commandLineArgs |> Array.filter isValidPerson |> Array.iter sayHello // this is a pipeline



// --------------------------------------
// WE CAN STACK THE PIPES VERTICALLY ----
// --------------------------------------
let isAllowedPerson person =
    person <> "Elon Musk" // <> means "different"

commandLineArgs
    |> Array.filter isValidPerson
    |> Array.filter isAllowedPerson
    |> Array.iter sayHello



// --------------------------------------
// PRESS A KEY TO EXIT ------------------
// --------------------------------------
Console.ReadKey() |> ignore
exit 0
