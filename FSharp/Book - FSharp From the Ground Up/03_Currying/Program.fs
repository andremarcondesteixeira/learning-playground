let add a b = a + b
let isSeven = add 2 5
let sumTwo = add 2
let isNine = sumTwo 7

let quote symbol content =
    sprintf "%c%s%c" symbol content symbol

let quoteWithSingleQuotes = quote '\''
let quoteWithDoubleQuotes = quote '"'

quoteWithSingleQuotes "I'm quoted with single quotes" |> printfn "%s"
quoteWithDoubleQuotes "I'm quoted with double quotes" |> printfn "%s"

exit 0
