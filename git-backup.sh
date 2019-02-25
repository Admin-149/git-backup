#!/usr/bin/env bash

INPUT="data.csv"

i=1

while IFS=',' read -r WORKREPO ACCESSTYPE LOGIN PASSWORD
do 
  test $i -eq 1 && ((i=i+1)) && continue # miss csv headers

  if [[ $ACCESSTYPE = 'key' ]]
  then
    # access by ssh key
    # key previously copied to ~/.ssh and add 'key' in data csv

    FOLD="$(cut -d'/' -f2 <<< $WORKREPO)" # separated folder name
    REP=$WORKREPO
  else
    # access by password
    # need add login and password for repo and delete 'key' in data csv 

    REP_NAME=${WORKREPO:8}
    REP="https://$LOGIN:$PASSWORD@$REP_NAME"
    FOLD="$(cut -d'/' -f3 <<< $REP_NAME)" # separated folder name
  fi

  FOLDER=${FOLD::-4} # removed '.git'

  if [ -d $FOLDER ] # check if folder exist
  then
    cd $FOLDER
    git pull --all
    cd ..
  else
    git clone $REP
  fi
done < "$INPUT"