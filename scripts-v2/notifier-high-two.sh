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

# Function to check for Dialog process, get its PID, and stop it if running
check_and_stop_dialog() {
    dialog_pid=$(pgrep -x "Dialog")
    if [ -n "$dialog_pid" ]; then
        echo "Dialog process is running with PID: $dialog_pid. Stopping it..."
        kill $dialog_pid
        
        # Wait for the process to stop
        for i in {1..5}; do
            if ! pgrep -x "Dialog" > /dev/null; then
                echo "Dialog process has been stopped successfully."
                return 0
            fi
            sleep 1
        done
        
        # If process is still running after 5 seconds, force kill it
        if pgrep -x "Dialog" > /dev/null; then
            echo "Dialog process did not stop gracefully. Force killing it..."
            kill -9 $dialog_pid
            sleep 1
        fi
        
        if ! pgrep -x "Dialog" > /dev/null; then
            echo "Dialog process has been forcefully stopped."
            return 0
        else
            echo "Failed to stop Dialog process. Exiting script."
            return 1
        fi
    else
        echo "Dialog process is not running. Continuing with the script."
        return 0
    fi
}

# Call the function to check for Dialog and stop it if running
if ! check_and_stop_dialog; then
    exit 1
fi

# If Dialog was not running or was successfully stopped, continue with the rest of the script
echo "Proceeding with the script execution."

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
    --blurscreen \
    --iconalpha 1.0 \
    --centericon \
    --width 600 \
    --ontop "true" \
    --height 400 \
    --progress \

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
