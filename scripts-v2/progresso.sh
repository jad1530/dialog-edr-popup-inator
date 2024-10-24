#!/bin/zsh

#Script to modify swiftDialog alerts within Crowdstrike either within RTR or in a Fusion workflow.
#Use this to modify the dialog with a progress bar during the remediation steps.

stage1="Identifying suspicious activity"
stage2="Stopping suspicious activity"
stage3="Removing files"
stage4="Cleaning up any traces"
stage5="Finishing up"
stage6="All done."

newtitle="Remediation in progress"
newmessage="We're working on removing threats from your computer.  \nPlease stand by."
remediationico="SF=washer.circle.fill,color=blue"
doneico="SF=checkmark.circle.fill,color=green,weight=medium"

#initial setup and resize
/bin/echo "progress: show" >> /var/tmp/dialog.log
/bin/echo "button1: disable" >> /var/tmp/dialog.log
/bin/echo "title: $newtitle" >> /var/tmp/dialog.log
/bin/echo "message: $newmessage" >> /var/tmp/dialog.log
/bin/echo "icon: $remediationico" >> /var/tmp/dialog.log
/bin/echo "width: 600" >> /var/tmp/dialog.log
/bin/echo "height: 400" >> /var/tmp/dialog.log

sleep 1
/bin/echo "progresstext: $stage1" >> /var/tmp/dialog.log

sleep 10
/bin/echo "progress: 20" >> /var/tmp/dialog.log
/bin/echo "progresstext: $stage2" >> /var/tmp/dialog.log

sleep 10
/bin/echo "progress: 40" >> /var/tmp/dialog.log
/bin/echo "progresstext: $stage3" >> /var/tmp/dialog.log

sleep 10
/bin/echo "progress: 60" >> /var/tmp/dialog.log
/bin/echo "progresstext: $stage4" >> /var/tmp/dialog.log

sleep 10
/bin/echo "progress: 80" >> /var/tmp/dialog.log
/bin/echo "progresstext: $stage5" >> /var/tmp/dialog.log

sleep 5
/bin/echo "progress: 100" >> /var/tmp/dialog.log
/bin/echo "progresstext: $stage6" >> /var/tmp/dialog.log

/bin/echo "button1: enabled" >> /var/tmp/dialog.log
/bin/echo "icon: $doneico" >> /var/tmp/dialog.log


exit
