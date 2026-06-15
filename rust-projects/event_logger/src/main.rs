// Write a program that appends a timestamped line to events.log
// using OpenOptions with .create(true).append(true).open() and SystemTime::now()
// Am not using SystemTime::now(), imported the chrono crate instead.

use std::fs::OpenOptions;
use std::io::Write;
use chrono::Local;

fn main() {
let mut file = OpenOptions::new()
    .append(true)
    .create(true)
    .open("events.log")
    .expect("Could not open events.log");

let now = Local::now();

writeln!(file, "Event updated at {}",now.format("%Y-%m-%d %H:%M:%S"))
    .expect("Could not write to events.log");

}
