#!/bin/bash

echo "# Removing packages"
for i in $(cat /tmp/packages_to_delete.txt); do sudo yum remove $i -y; done
