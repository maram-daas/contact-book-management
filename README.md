# x86 Assembly Contact Book

A Contact Book mangement program written in **x86 Assembly (16-bit)**, built using macros and procedures. It supports adding, deleting, modifying, searching, and listing contacts.

---

## Architecture & Platform

- **Instruction set**: x86 (Intel 8086/80186/80286 compatible)
- **Mode**: 16-bit Real Mode
- **Memory model**: Small (1 code segment, 1 data segment)

---

## Features

- Add a new contact (name + number)
- View all saved contacts
- Delete a contact by name
- Modify an existing contact's number
- Search for contacts by:
  - full name
  - a chosen name prefix
  - a chosen number prefix
- Input validation and capacity checks (max 16 contacts)

---

## Data structure

The contact book is a contiguous memory block with:
- 1 byte at the beginning storing the current number of contacts
- Maximum of 16 contacts 

Each contact is stored in memory as:
- **Name**: 10 character max (+ $ terminator)
- **Number**: 10 character max (+ $ terminator)

---

## How to build and run

- Anything that runs x86 assembly, I recommend using emu8086, you can download it from anywhere.

> you'll need a registration code to use it, so you can simply contact me and i'll share it with you. Take care <33

---

## License

This project is licensed under the Apache License 2.0
