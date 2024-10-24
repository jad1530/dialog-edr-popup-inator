#!/bin/zsh
#set -x

#Huge shoutout to Trevor Sysock (@BigMacAdmin on Slack) and @adamcodega for helping with these
#Script to launch swiftDialog alerts within Crowdstrike either within RTR or in a Fusion workflow.
#this alert is a complete script for running remediation.

#local swiftDialog path
dialogPath="/usr/local/bin/dialog"

#Initial text
dialogTitle="Remediation in progress"
dialogMessage="We're working on removing threats from your computer.  \nPlease stand by.  \n\nThis message will remain on your screen until the issue is resolved."
dialogInfoText="This is an official message from IT."
dialogIcon="SF=washer.circle.fill,color=blue"

#identify the remediation stages
stage1="Identifying location and impact of threats"
stage2="Stopping programs and processes associated with threats"
stage3="Removing files"
stage4="Cleaning up any traces"
stage5="Finishing up"
stage6="All done."

#identify the duration of remediation
#placeholder - will see if I can identify when CS does a thing
stage1time=10
stage2time=10
stage3time=10
stage4time=10
stage5time=10

dialogCommandFile="/var/tmp/dialog.log"

# Button 1 Text
button1text="Continue"

"$dialogPath" \
    --title "$dialogTitle" \
    --message "$dialogMessage" \
    --icon "$dialogIcon" \
    --infotext "$dialogInfoText" \
    --messageposition center \
    --messagealignment center \
    --position center \
    --button1disabled \
    --iconalpha 1.0 \
    --centericon \
    --width 35% \
    --ontop "true" \
    --height 40% \
    --progress \
    -b \

    #Very important that this part comes immediately after the dialog command
    dialogResults=$?

    echo "Dialog exited with the following code: $dialogResults"

    if [ "$dialogResults" = 0 ]; then
        echo "User acknowledged, continue investigation."
    elif [ "$dialogResults" = 10 ]; then
        echo "Exit key was used - user was prompted to exit."
    else
        echo "Dialog exited with an unexpected code."
        echo "Could be an error in the dialog command"
        echo "Could be the process killed somehow."
        echo "Exit with an error code."
        exit "$dialogResults"
    fi
    
exit
