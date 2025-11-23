#!/bin/bash

db_set() {
    echo "$1,$2" >> database
}

db_get() {
    # previous version was:
    # grep "^$1," database | sed -e "s/^$1,//" | tail -n 1
    # the problem with this is that it always scans the entire file

    # tac reads the file in reverse (last line first)
    # grep -m 1 stops processing immediately after finding the first match
    tac database | grep -m 1 "^$1," | sed -e "s/^$1,//"
}
