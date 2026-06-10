What is /, /etc, /home, /usr, /var, /proc 

/ is the root directory, which holds...everything! 
It is the core trunk from which all other directories are built

/etc is et cetera, editable text config -- system config
It stores system-wide configuration files
Holds the network settings, user account info

/home is the personal space for regular users' data -- user files
It holds, for example, in /home/alex, alex's documents, downloads, personal
settings

/usr is not user, but rather Unix System Resource -- installed applicationss
It holds system's user-space (user-level) applications, libraries, & documentation
keeps system organized and bootable, even if only root partition is available

/var is for variable -- logs & runtime data
Stores files that change frequently during sys ops,
like logs, caches, spool files.
i.e., /var/log = system logs that track activity and errors
used for troubleshooting and managing disk space

/proc is for processes -- live kernel state
it is the live interfact to Linux kernel and running processes
Virtual file system for dynamic, in-memory view of system
Vital tool for monitoring, debugging, and interacting with system's inner
workings in real-time
i.e., /proc/1234; /proc/cpuinfo  
