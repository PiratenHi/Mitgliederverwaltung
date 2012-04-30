#!/bin/bash

sqlite -separator ";" db.sq3 'select * from semkol' > dump/dump_$(date "+%Y-%m-%d_%H_%M_%S").csv
cat import.sqlite | sqlite db.sq3
cat misc.sql | sqlite db.sq3
