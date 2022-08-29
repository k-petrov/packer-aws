#!/bin/bash

echo "# Removing packages"
for i in $(cat packer-aws/packages_to_delete.txt); do yum remove $i -y; done
