# dialog-edr-popup-inator
swiftDialog based popups to deploy as scripts when doing things with EDR.
I set up these scripts to deploy bold pop-ups to users for a couple of scenarios that may happen when I'm investigating or remediating a machine:
+ If our EDR detecs a threat of "high" or greater and thus warrants temporarily blocking out the user while we investigate and remediate
+ As an extra automated "warning" during a detection.
+ To give users feedback while we're remediating a threat

These scripts were inspired by a [DEPNotify workflow](https://www.jamf.com/blog/jamf-protect-remediation-workflows/) that I'd seen in Jamf Protect before.

These scripts are designed to work with Crowdstrike, utilizing the scripting functionality in Real-Time Response (RTR) and the ability to expose RTR scripts to Fusion workflows.
However, they *should* work with any endpoint protection product or EDR that can send and execute shell scripts on macOS.
They're still a work in progress so keep that in mind if you decide to use em!

## Things to do
* Update the timeout logic to terminate if an exit key was pressed or if a button was pressed early.
* Update progresso.sh with actual progress determinants
