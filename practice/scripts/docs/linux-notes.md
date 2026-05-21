docs/linux-notes.md answering: What is a shell? What is PATH? What does chmod +x do? What is the difference between bash scripts/hello.sh and ./scripts/hello.sh?

What is a shell?
A shell is a...lowkey hard thing to describe, It is a program that gives you a text interface to your computer's Operating System.
It's also a "mini" programming language (if/else)
It has features (cd) and also manages other external programs like grep

What is PATH?
PATH is the "map" or list of folders where the shell looks for executable programs when you type a command name
When I type a command like python3 or grep, the shell searches those folders to find the actual program to run.

What does chmod +x do?
Changes user permissions to execute a program

What is the difference between bash scripts/hello.sh and ./scripts/hello.sh?
former = "shell, run this text file"; "Hey sh, please read and run this file."
latter = "computer, run this file as a program"
