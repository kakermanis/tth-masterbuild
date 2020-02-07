#!/bin/bash

SCRATCH_PWD=$DX_ENC_PWD
read -p 'Scratch default username: ' scratchUser
read -p 'Test or Prod [t/p]?: ' targetInstance

if [ "$targetInstance" == 't' ]; then
  ./scripts/bash/loadProdData.sh $scratchUser $SCRATCH_PWD https://test.salesforce.com
fi

if [ "$targetInstance" == 'p' ]; then
  ./scripts/bash/loadProdData.sh $scratchUser $SCRATCH_PWD https://login.salesforce.com
fi
