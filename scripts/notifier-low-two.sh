#!/bin/zsh
#set -x

#Huge shoutout to Trevor Sysock (@BigMacAdmin on Slack) and @adamcodega for helping with these
#Script to launch swiftDialog alerts within Crowdstrike either within RTR or in a Fusion workflow.
#this alert style is intended to represent a "low" severity alert, and therefore doesn't need the background.

dialogPath="/usr/local/bin/dialog"

# How many seconds do you want to delay the OK button. Users will not be able to dismiss the Dialog window for this many seconds.
delayButtonDuration=15

dialogTitle="IT security alert"
dialogMessage="We've detected suspicious activity on your computer.  \nPlease contact IT for guidance."
dialogInfoText="This is an official message from JWA IT."
dialogIcon="SF=exclamationmark.circle.fill,color=yellow,weight=medium"

dialogCommandFile="/var/tmp/dialog.log"

# Button 1 Text
button1text="Continue"

# execute a dialog command
function dialog_command(){
    /bin/echo "$@"  >> "$dialogCommandFile"
    log_message "$@"
    sleep .1
}

function delayed_button_enablement(){

    while [ $delayButtonDuration -gt 0 ]; do
        dialog_command "button1text: Dismiss in $delayButtonDuration..."
        sleep .9
        delayButtonDuration=$(( delayButtonDuration -1 ))
    done
    dialog_command "button1text: $button1text"
    dialog_command "button1: enable"
}

(
"delayed_button_enablement" & "$dialogPath" \
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
    --width 600 \
    --ontop "true" \
    --height 400 \


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
