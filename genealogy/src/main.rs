use std::collections::HashMap;
use std::error::Error;
use std::io;
use std::process;

use serde::Deserialize;

#[derive(Debug, Deserialize)]
struct PersonRecord {
    birthdate: String,
    name: String,
    father: String,
    mother: String,
}

// struct Person {
//     name: String,
//     father: Option<*mut Person>,
//     mother: Option<*mut Person>,
// }

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

fn build_tree(recs: std::vec::Vec<PersonRecord>) -> HashMap<String, &'static mut Person<'static>> {
    let mut map = HashMap::new();

    for rec in recs {
        let mut p = Person{
            name: &rec.name,
            father: None,
            mother: None,
        };

        let mp = &mut p;

        map.insert(rec.name, mp);
    }

    return map;
}

#[derive(PartialEq)]
struct Person<'a> {
    name: &'a str,
    mother: Option<Box<Person<'a>>>,
    father: Option<Box<Person<'a>>>,
}
impl<'a> Person<'a> {
    pub fn insert(&mut self, new_val: &'a str) {
        if self.name== new_val {
            return;
        }
        let target_node = if new_val < self.name {
            &mut self.mother
        } else {
            &mut self.father
        };
        match target_node {
            &mut Some(ref mut subnode) => subnode.insert(new_val),
            &mut None => {
                let new_node = Person {
                    name: new_val,
                    mother: None,
                    father: None,
                };
                let boxed_node = Some(Box::new(new_node));
                *target_node = boxed_node;
            }
        }
    }

    pub fn set_mother(&mut self, mother: &'a str) {
        let target_person = &mut self.mother;

        let new_person = Person {
            name: mother,
            mother: None,
            father: None,
        };

        let boxed_person = Some(Box::new(new_person));
        *target_person = boxed_person;
    }

    pub fn set_father(&mut self, father: &'a str) {
        let target_person = &mut self.father;

        let new_person = Person {
            name: father,
            mother: None,
            father: None,
        };

        let boxed_person = Some(Box::new(new_person));
        *target_person = boxed_person;
    }
}

fn main() {
    let mut x = Person {
        name: "m",
        mother: None,
        father: None,
    };
    x.insert("z");
    x.insert("b");
    x.insert("c");
    assert!(
        x == Person {
            name: "m",
            mother: Some(Box::new(Person {
                name: "b",
                mother: None,
                father: Some(Box::new(Person {
                    name: "c",
                    mother: None,
                    father: None
                })),
            })),
            father: Some(Box::new(Person {
                name: "z",
                mother: None,
                father: None
            })),
        }
    );
}

// fn main() {
//     let records = parse();
//     match records {
//         Ok(recs) => {

//         },
//         Err(err) => {
//             println!("Error parsing records: {:?}", err);
//             process::exit(1);
//         }
//     }
// }
