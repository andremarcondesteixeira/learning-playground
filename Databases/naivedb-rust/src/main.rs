use std::env;
use std::fs;
use std::io::{Write, Error};
use rev_lines::RevLines;

fn main() -> Result<(), Error> {
    let args: Vec<String> = env::args().collect();

    if args.len() == 1 {
        println!("Usage:");
        println!("    get [key]          Gets a value by key");
        println!("    set [key] [value]  Sets a value by key");
        return Ok(());
    }

    let operation = &args[1];
    match operation.as_str() {
        "get" => {
            if args.len() != 3 {
                println!("Usage: get [key]");
                return Ok(());
            }

            let key = &args[2];
            get(key)

        }
        "set" => {
            if args.len() != 4 {
                println!("Usage: set [key] [value]");
                return Ok(());
            }

            let key = &args[2];
            let value = &args[3];
            set(key, value)
        }
        _ => {
            println!("Unknown operation");
            Ok(())
        }
    }
}

fn get(key: &str) -> Result<(), Error> {
    let file = fs::OpenOptions::new()
        .read(true)
        .write(true) // only to be able to create the file in case it does not exists
        .create(true)
        .open("database")?;

    let lines = RevLines::new(file);

    for line in lines {
        if let Ok(line) = line {
            if line.starts_with(&format!("{key},")) {
                let key_value_pair = line.split(',').collect::<Vec<&str>>();
                println!("{}", key_value_pair[1]);
                return Ok(());
            }
        }
    }

    Ok(())
}

fn set(key: &str, value: &str) -> Result<(), Error> {
    let mut file = fs::OpenOptions::new()
        .append(true)
        .create(true)
        .open("database")?;

    writeln!(file, "{key},{value}")?;

    Ok(())
}
