## Setting up the fingerprint reader in Asus Vivobook M3500QA (or similar) in Omarchy

### 1) Install the necessary libraries

`sudo pacman -Syu fprintd libfprint`

### 2) Enroll a finger

`fprintd-enroll $USER`

When enrolling, make sure you swipe your finger from the bottom up very gently. It should take about 2 seconds the entire swap. During our testing, we had to swipe 6 times for it to finish the proces.

### 3) Enable in PAM (add above the password line)

To enable in PAM you have to add a line in several files:

- `sudoedit /etc/pam.d/sudo`

add: auth sufficient pam_fprintd.so

- `sudoedit /etc/pam.d/system-local-login`

add: auth sufficient pam_fprintd.so

- `sudoedit /etc/pam.d/login`

add: auth sufficient pam_fprintd.so

- `sudoedit /etc/pam.d/polkit-1`

add: auth sufficient pam_fprintd.so

### 4) Verify your fingerprint

`fprintd-verify $USER`

You are all set.
