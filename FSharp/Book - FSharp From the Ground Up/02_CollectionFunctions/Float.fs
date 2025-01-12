module Float
open System
open System.Globalization

let tryFromString (s: string): float option =
    let isNumber, number = Double.TryParse(s, NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture)
    
    if isNumber then
        Some(number)
    else
        None

let fromStringOr (defaultValue: float) (s: string) : float =
    s |> tryFromString |> Option.defaultValue defaultValue
