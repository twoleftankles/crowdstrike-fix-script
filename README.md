**NON BIT LOCKER MACHINES ONLY**
IM VERY AWARE MICROSOFT RELEASED A TOOL.

This script will auto-mount all partitions available and find the problematic update files, then delete them. It outputs the logs to the Desktop for the local user to verify the removal of the files.

This script was primarily made to act a as a back up in the event that recovery USB fails on some systems. Personally, I created a live bootable USB with a service that auto runs this script and configured an SSH server so I can remote troubleshoot if needed.

This has gone through very limited testing in my virtual environment, please let me know how I could improve it!
