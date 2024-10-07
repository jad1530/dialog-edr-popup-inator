#!/bin/zsh
#set -x

#Huge shoutout to Trevor Sysock (@BigMacAdmin on Slack) and @adamcodega for helping with these
#Script to launch swiftDialog alerts within Crowdstrike either within RTR or in a Fusion workflow.
#this alert style is intended to represent an "all clear".

dialogPath="/usr/local/bin/dialog"

# How many seconds do you want to delay the OK button. Users will not be able to dismiss the Dialog window for this many seconds.
delayButtonDuration=15

dialogTitle="Remediation complete"
dialogMessage="We've successfully removed threats from your computer.  \nPlease save your work and reboot.  \nYou may dismiss this message in a few seconds."
dialogInfoText="This is an official message from JWA IT."
dialogIcon="SF=checkmark.circle.fill,color=green,weight=medium"

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

#restart command
function exec_restart()
{

log_message "Executing restart!"

#This is the restart command. Thank you Dan Snelson: https://snelson.us/2022/07/log-out-restart-shut-down/

osascript -e 'tell app "loginwindow" to «event aevtrrst»'

}

fi

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
    --width 35% \
    --ontop "true" \
    --height 40% \
    --timer 120 \
    --hidetimerbar \
    --button2text "Restart" \
    -b

    #Very important that this part comes immediately after the dialog command
    dialogResults=$?

    echo "Dialog exited with the following code: $dialogResults"

    if [ "$dialogResults" = 0 ]; then
        echo "User closed window - all done."
    elif [ "$dialogResults" = 2 ]; then
        osascript -e 'tell app "loginwindow" to «event aevtrrst»'
        echo "User selected restart button."
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
