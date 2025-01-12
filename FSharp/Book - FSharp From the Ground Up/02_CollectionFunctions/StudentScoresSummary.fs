module StudentScoresSummary

// this is a record type
type StudentScoresSummary = {
    Name: string
    Id: string
    MeanScore: float
    MinScore: float
    MaxScore: float
}

let fromString (s: string): StudentScoresSummary =
    let pieces = s.Split("\t")
    let name = pieces.[0]
    let id = pieces.[1]
    let scores = pieces[2..] |> Array.map (Float.fromStringOr 50)
    let meanScore = Array.average scores
    let minScore = Array.min scores
    let maxScore = Array.max scores
    
    {
        Name = name
        Id = id
        MeanScore = meanScore
        MinScore = minScore
        MaxScore = maxScore
    }

let printSummary (summary: StudentScoresSummary) =
    // the %0.6f format specifier has the following format:
    // %<0 if want to pad left><total length of number including numbers after the point>.<amount of numbers after the point>
    printfn "%s: mean: %06.2f, min: %06.2f, max: %06.2f - %s"
        summary.Id
        summary.MeanScore
        summary.MinScore
        summary.MaxScore
        summary.Name
