# Helper Functions for bash

This repository provides helper functions for `bash` applications.

NOTE: It is recommended that you do _not_ source this file directly into an interactive terminal as any typo or missing variable will cause the shell to exit.

We use the following `set` configuration (descriptions from `man bash`):

* `-e`: Exit immediately if a pipeline exits with a non-zero status
* `-u`: Treat unset variables and parameters other than the special parameters "@" and "*" as an error when performing parameter expansion

## Function List

### Logging

* `logInfo`
    * Simple log function that prints to standard out with command sequences supported

* `logError`
    * Simple log function that prints to standard error with command sequences supported

### Process Management

* `checkProcessIsAlive`
    * Checks the specified PID to determine it is running on the current host

### CSV Config Loading

* `loadConfigFile`
    * Loads a CSV file, ignoring any lines that begin with a hash (`#`) or a space

* `getConfigFileColumn`
    * Returns an array of the specified column from a CSV file

* `getConfigFileRowsStrMatch`
    * Returns the rows of a CSV file that match a specified regex 

### Other

* `ensurePathEndsInSlash`
    * Takes a string path and appends a slash (`/`) if the path does not already end in one. Otherwise returns the string unmodified

* `arrayContains`
    * Checks if a specified string exists within an array

* `getPreviousPartialDate`
    * Returns a historical date based on a period and unit of time from today

## Examples

