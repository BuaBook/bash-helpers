#!/usr/bin/env bash

## BuaBook Common Bash Functions
## Copyright (c) Sport Trades Ltd 2015 - 2017

set -eu

# Log to standard out (with command sequences supported, e.g. \n)
logInfo()
{
    echo -e "$*"
}

# Log to standard error (with command sequences supported, e.g. \n)
logError()
{
    echo -e "$*" >&2
}


# Takes a string path and returns the path with a forward slash appended to it if necessary.
ensurePathEndsInSlash()
{
    if [[ $# -gt 1 ]]; then
        logError "Only 1 argument permitted ($# passed)"
        return 1
    fi

    local path=$1
    local pathLength=${#path}

    if [[ ${path:$pathLength - 1:1} != "/" ]]; then
        path="${path}/"
    fi

    echo $path
    return 0
}

# Outputs the exit status of "kill -0" to determine if the specified PID
# is currently running on this host. 0 is echoed if the PID exists, 1 otherwise.
#  @param $1 A PID to check
checkProcessIsAlive()
{
    local pid=$1

    if [[ $pid == "" ]]; then
        logError "No PID specified to check"
        return 1
    fi

    echo $(kill -0 $pid > /dev/null 2>&1; echo $?)
    return 0
}

# Checks if the specified array contains a specified string
#  @param $1 The string to look for in the array
#  @param $2 The array to look in
arrayContains()
{
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

# Reads in the specified configuration file, removing comments and blank lines
loadConfigFile()
{
    local configFile=$1

    if [[ $configFile == "" ]]; then
        return 1
    fi

    if [[ ! -e $configFile ]]; then
        return 2
    fi

    echo -e "$(grep -ve "^#\|^$" $1)"
    return 0
}

# Returns the specified column of a supported config file (CSV)
#  @param $1 configFile The file to load
#  @param $2 column The column to return
#  @see loadConfigFile
getConfigFileColumn()
{
    local configFile=$1
    local column=$2

    if [[ $configFile == "" ]] || [[ $column == "" ]]; then
        return 1
    fi

    echo -e "$(loadConfigFile $configFile | awk -F',' " { print \$$column } ")"
}

# Returns the rows from the specified configuration file that contain the specified string
getConfigFileRowsStrMatch()
{
    local configFile=$1
    local strToMatch=$2

    local configRows=($(loadConfigFile $configFile))

    for configRow in "${configRows[@]}"; do
        if [[ $configRow == *${strToMatch}* ]]; then
            echo "$configRow"
        fi
    done
}

# Returns a historical partial date based on the period and unit of time specified in yyyymmdd format.
# Useful for archiving of old data.
# Example when today's date is 20170207:
#  > getPreviousPartialDate 1 month = 201701
#  > getPreviousPartialDate 3 day = 20170204
#  > getPreviousPartialDate 5 year = 2012
#  @param $1 The period of time to go back
#  @param $2 The unit of time to use. 'day', 'month', 'year' supported
getPreviousPartialDate()
{
    local periodCount=$1
    local periodType=$2

    local customInputDate=""
    local returnType=""
    
    if [[ $periodType == "day" ]]; then
        returnType="+%Y%m%d"
    elif [[ $periodType == "month" ]]; then
        returnType="+%Y%m"
        customInputDate=$(date +%Y-%m-01)
    elif [[ $periodType == "year" ]]; then
        returnType="+%Y"
    else
        return 1
    fi

    echo $(date -d "$customInputDate - $periodCount $periodType" $returnType)
    return 0
}
