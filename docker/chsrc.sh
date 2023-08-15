#!/bin/bash

# Source Openssh
chown -Rv _apt:root /var/cache/apt/archives/partial/
chmod -Rv 700 /var/cache/apt/archives/partial/
apt-get build-dep openssh --no-install-recommends --yes
apt-get source openssh --no-install-recommends --yes
cd openssh-8.2p1/

# in auth-passwd.c file
# finds 2 instances of "strcut passwd *pw = authctxt->pw;"
# and adds a line "logit("Login Attempt by USERNAME: %s, PASSWORD: %s", authctxt->user, password);"

sed -e 's/^\([ \t]*\)\(struct passwd \*pw = authctxt->pw;\)/\1logit("Login attempt by username '\''%s'\'', password '\''%s'\''", authctxt->user, password);\n\1\2/' -i auth-passwd.c

# Commit those changes and build the package
debchange --nmu 'ADDED VERBOSE LOGGING OF USERNAMES AND PASSWORDS - aatharvauti'
EDITOR=true dpkg-source --commit . 'honeytrack-test.patch'

debuild -us -uc -i -I
debi
mkdir /run/sshd

echo ok
# Clean files and Packages
apt clean && apt autoremove