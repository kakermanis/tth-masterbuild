function dxpush() {
if [$# -eq 0 ];
   then
      sfdx force:source:push
   else
      sfdx force:source:push -u $@
fi
}

function dxpull() {
if [ $# -eq 0 ];
then
    sfdx force:source:pull
else
    sfdx force:source:pull -u $@
fi
}

function dxopen() {
if [ $# -eq 0 ];
then
   sfdx force:org:open
else
   sfdx force:org:open -u $@
fi
}

function dxstatus() {
if [ $# -eq 0 ];
then
   sfdx force:source:status
else
   sfdx force:source:status -u $@
fi
}

function packlist() {
  sfdx force:package:version:list $@
}

function orglist() {
   sfdx force:org:list --all
}

function cscratch() {
   sfdx force:org:create -s -f config/project-scratch-def.json -a $@
}

function dscratch() {
   sfdx force:org:delete --noprompt -u $@
}

function defscratch() {
   sfdx force:config:set defaultusername=$@
}
