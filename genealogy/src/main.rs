use std::error::Error;
use std::io;
use std::process;
use std::collections::HashMap;

use serde::Deserialize;

#[derive(Debug, Deserialize)]
struct PersonRecord {
    birthdate: String,
    name: String,
    father: String,
    mother: String,
}

struct Person {
    name: String,
    father: Option<*mut Person>,
    mother: Option<*mut Person>,
}

fn parse() -> Result<std::vec::Vec<PersonRecord>, Box<dyn Error>> {
    let mut rdr = csv::Reader::from_reader(io::stdin());
    let mut vec = Vec::new();
    for result in rdr.deserialize() {
        // Notice that we need to provide a type hint for automatic
        // deserialization.
        let record: PersonRecord = result?;
        vec.push(record);
    }
    Ok(vec)
}

fn build_tree(recs: std::vec::Vec<PersonRecord>) -> HashMap<String, *mut Person> {
    let mut map = HashMap::new();

    for rec in recs {
        let p = Person{
            name: rec.name,
            father: None,
            mother: None,
        };

        let mp = &mut p;

        map.insert(p.name, mp);
    }

    return map;
}

fn main() {
    let records = parse();
    match records {
        Ok(recs) => {

        },
        Err(err) => {
            println!("Error parsing records: {:?}", err);
            process::exit(1);
        }
    }
}
