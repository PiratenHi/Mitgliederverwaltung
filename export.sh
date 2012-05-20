#!/bin/bash

sqlite -separator ";" db.sq3 'select * from semkol' > semkol_20120203.csv
sqlite -separator ";" db.sq3 'select * from kreisverbaende' > kreisverbaende.csv
