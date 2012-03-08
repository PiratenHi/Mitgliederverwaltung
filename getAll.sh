#!/bin/bash

ALL_LK="Hildesheim Göttingen"

for LK in $ALL_LK ; do

  echo "packing $LK"
  ./landkreis $LK
  
done
