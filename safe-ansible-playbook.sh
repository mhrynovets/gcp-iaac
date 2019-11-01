#!/bin/bash

INVENTORY=$1
INCOMING_KEY=$2
KEY=$INCOMING_KEY.$((1 + RANDOM % 9999))

ANSIBLE_ROOT=$3
PLAYBOOK=$4

cp $INCOMING_KEY $KEY
chmod 400 $KEY
mkdir -p $ANSIBLE_ROOT/external_roles
ansible-galaxy install --ignore-errors --roles-path $ANSIBLE_ROOT/external_roles -r $ANSIBLE_ROOT/external_roles.yml
ansible-playbook --private-key=$KEY --inventory-file=$INVENTORY $ANSIBLE_ROOT/$PLAYBOOK
RES=$?
rm -f $KEY
exit $RES
