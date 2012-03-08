#!/bin/bash
perl bezahlt.pl $1 $2 $3 $4 | patch $1 -


