use std::fs;
use std::fs::File;
use std::io::{self, BufRead, BufReader, Write};
use std::net::TcpListener;

fn main() -> io::Result<()> {
    let mut db = NaiveDB::new()?;
    db.rebuild_index()?;
    println!("Index loaded");

    let listener = TcpListener::bind("127.0.0.1:7878")?;
    println!("listening on 127.0.0.1:7878");

    for stream_result in listener.incoming() {
        let stream = match stream_result {
            Ok(stream) => stream,
            Err(err) => {
                eprintln!("Error connecting to client: {err}");
                continue;
            }
        };

        println!("client connected: {}", stream.peer_addr()?);

        let mut reader = BufReader::new(stream.try_clone()?);
        let mut writer = stream;

        loop {
            let mut line = String::new();
            let bytes = reader.read_line(&mut line)?;

            if bytes == 0 {
                println!("client disconnected");
                break;
            }

            let line = line.trim();

            match Command::parse(line) {
                Ok(cmd) => match db.handle_command(cmd) {
                    Ok(result) => {
                        writeln!(writer, "OK: {}", result)?;
                        writer.flush()?;
                    }
                    Err(e) => {
                        writeln!(writer, "ERR: {}", e)?;
                        writer.flush()?;
                    }
                },
                Err(e) => {
                    writeln!(writer, "ERR: {}", e)?;
                    writer.flush()?;
                }
            }
        }
    }


    Ok(())
}

struct NaiveDB {
    index: std::collections::HashMap<String, String>,
    file: File,
}

impl NaiveDB {
    pub fn new() -> io::Result<Self> {
        let file = fs::OpenOptions::new()
            .read(true)
            .write(true) // only to be able to create the file in case it does not exists
            .create(true)
            .open("database")?;

        Ok(Self {
            index: std::collections::HashMap::new(),
            file,
        })
    }

    pub fn handle_command(&mut self, cmd: Command) -> Result<String, String> {
        match cmd {
            Command::Get(k) => self.get(&k).ok_or_else(|| "not found".to_string()),
            Command::Set(k, v) => self
                .set(k, v)
                .map(|_| "".to_owned())
                .map_err(|e| e.to_string()),
            Command::RebuildIndex => self
                .rebuild_index()
                .map(|_| "".to_owned())
                .map_err(|e| e.to_string()),
        }
    }

    pub fn get(&self, key: &str) -> Option<String> {
        self.index.get(key).cloned()
    }

    pub fn set(&mut self, key: String, value: String) -> io::Result<()> {
        let result = writeln!(self.file, "{key},{value}");

        if result.is_ok() {
            self.index.insert(key, value);
        }

        result
    }

    pub fn rebuild_index(&mut self) -> io::Result<()> {
        BufReader::new(self.file.try_clone()?);

        for line in BufReader::new(self.file.try_clone()?).lines() {
            match line {
                Ok(line) => {
                    let parts: Vec<&str> = line.split(',').collect();
                    let (key, value) = (parts[0].to_string(), parts[1].to_string());
                    self.index.insert(key, value);
                }
                Err(e) => {
                    eprintln!("Error when rebuilding index: {e}");
                }
            }
        }

        Ok(())
    }
}

enum Command {
    Get(String),
    Set(String, String),
    RebuildIndex,
}

impl Command {
    pub fn parse(input: &str) -> Result<Self, String> {
        let mut parts = input.split_whitespace();
        let cmd = parts.next().ok_or("empty command")?;

        match cmd {
            "get" => {
                let key = parts.next().ok_or("missing key")?;
                Ok(Command::Get(key.into()))
            }
            "set" => {
                let key = parts.next().ok_or("missing key")?;
                let val = parts.next().ok_or("missing value")?;
                Ok(Command::Set(key.into(), val.into()))
            }
            "rebuild-index" => Ok(Command::RebuildIndex),
            _ => Err(format!("unknown command '{cmd}'")),
        }
    }
}
