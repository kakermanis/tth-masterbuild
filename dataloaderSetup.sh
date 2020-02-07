#!/bin/bash

DL_KEY_FILE=data/prod/config/login.key
DL_JAR_FILE=bin/dataloader/dataloader.jar

if [ -f "$DL_JAR_FILE" ]; then
  #echo "Dataloader jar file exists"
  read -p 'Org Default Password: ' DX_PASS

  if [ -f "$DL_KEY_FILE" ]; then
  #    echo "Dataloader PWD Keyfile $DL_KEY_FILE exists"
  echo ''
  else
      echo "...Dataloader PWD Keyfile $DL_KEY_FILE does not exist. Generating one for you"
      java -cp bin/dataloader/dataloader.jar com.salesforce.dataloader.security.EncryptionUtil -k data/prod/config/login.key
  fi

  # Encrypt the default password
  ENCRYPT_RESULT=$(java -cp bin/dataloader/dataloader.jar com.salesforce.dataloader.security.EncryptionUtil -e $DX_PASS data/prod/config/login.key | sed -n '1!p')
  #Remove any whitespace
  ENCRYPT_RESULT="$(echo -e "${ENCRYPT_RESULT}" | sed -e 's/^[[:space:]]*//')"

  # Tell user to edit bashrc with necessary variables
  echo 'Please add the following environement variables to your .bashrc file: '
  echo ''
  echo 'export DX_ENC_PWD='$ENCRYPT_RESULT
  echo 'export DX_DEF_PWD='${DX_PASS}
  echo ''

else
  echo "You need to download and the forcedotcom dataloader - find out how here: https://help.salesforce.com/articleView?id=loader_install_general.htm"
  echo "Then you need to copy the dataloader JAR file [named similar to dataloader-VERSION-uber.jar], place it in <DX Project Root>/bin/dataloader and rename it to dataloader.jar"
fi
