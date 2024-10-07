#!/bin/zsh
#set -x

#Huge shoutout to Trevor Sysock (@BigMacAdmin on Slack) and @adamcodega for helping with these
#Script to launch swiftDialog alerts within Crowdstrike either within RTR or in a Fusion workflow.
#this alert style is intended for the highest severity of alerts.

dialogPath="/usr/local/bin/dialog"

dialogTitle="IT security alert"
dialogMessage="We've detected suspicious activity on your computer.  \nPlease stop your work **immediately** and contact IT for guidance.  \n\nThis message will remain on your screen until the issue is resolved."
dialogInfoText="This is an official message from JWA IT."
dialogIcon="warning"

dialogCommandFile="/var/tmp/dialog.log"

# Button 1 Text
button1text="Continue"

(
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
    --blurscreen \
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
)&

exit
