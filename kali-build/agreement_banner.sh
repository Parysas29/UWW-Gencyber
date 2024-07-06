#!/bin/bash
message="This device has been configured for use during the GenCyber Camp and is prohibited from connecting to the university Main or Guest WiFi. 

By using this laptop, you agree to abide by these terms. Press Enter on Yes to show that you confirmed."

# Display message and agreement prompt
dialog --title "GenCyber Camp User Agreement" \
       --yesno "${message}" \
       80 120 

# Check user selection (returns 0 for OK, 1 for Cancel)
if [ $? -eq 0 ]; then
  dialog --msgbox "Thank you for agreeing to the terms. You may now proceed using the laptop." 80 120
else
  xfce4-session-logout -h
  dialog --msgbox "User agreement not accepted. Logging Out Now." 80 120
  exit 1  # Exit script with non-zero code to indicate failure
fi
