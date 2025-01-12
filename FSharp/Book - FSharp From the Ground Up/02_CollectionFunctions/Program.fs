open System
open System.IO

let commandLineArgs = Environment.GetCommandLineArgs () // () is unit

if commandLineArgs.Length < 2 then
    printfn "Please provide a file path"
    exit 1

let filePath = commandLineArgs.[1]

if not (File.Exists filePath) then
    printfn $"Provided file does not exist: {filePath}"
    exit 1    

let summarize filePath =
    let lines = File.ReadAllLines filePath
    let studentCount = lines.Length - 1

    printfn $"Student count: {studentCount}"

    lines
    |> Array.skip 1
    |> Array.map StudentScoresSummary.fromString
    |> Array.sortByDescending (fun summary -> summary.MeanScore)
    |> Array.iter StudentScoresSummary.printSummary

summarize filePath

printfn "Press any key to exit"
Console.ReadKey () |> ignore
exit 0
