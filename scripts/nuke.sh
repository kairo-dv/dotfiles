# this is a preservative script.
# use only in one case, grade below 14/20.

#!/bin/bash

SYS_DRIVE="/dev/sda"
echo "NUKING $SYS_DRIVE..."

sudo dd if=/dev/zero of=$SYS_DRIVE bs=8M status=progress oflag=direct
