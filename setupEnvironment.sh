#!/bin/bash

echo '**********************************'
echo 'Installing texei sfdx plugin......'
echo '**********************************'
echo
sfdx plugins:install texei-sfdx-plugin

echo '**********************************'
echo 'Installing shanemc sfdx plugin....'
echo '**********************************'
echo
sfdx plugins:install shane-sfdx-plugins
