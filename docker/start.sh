echo "

██╗  ██╗ ██████╗ ███╗   ██╗███████╗██╗   ██╗████████╗██████╗  █████╗  ██████╗██╗  ██╗
██║  ██║██╔═══██╗████╗  ██║██╔════╝╚██╗ ██╔╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝
███████║██║   ██║██╔██╗ ██║█████╗   ╚████╔╝    ██║   ██████╔╝███████║██║     █████╔╝
██╔══██║██║   ██║██║╚██╗██║██╔══╝    ╚██╔╝     ██║   ██╔══██╗██╔══██║██║     ██╔═██╗
██║  ██║╚██████╔╝██║ ╚████║███████╗   ██║      ██║   ██║  ██║██║  ██║╚██████╗██║  ██╗
╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝


"

echo "Please make sure that you're running this script as root!
For more documentation about the program, visit https://auti.dev/honeytrack
"

echo "
"

# PATH where Honeypot scripts are stored
LOGFILES=/var/log/dnsrout

# Start SSH and permit "root" login
echo "SSH Service is Starting............"
service ssh start
sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
service ssh restart
service ssh status

echo "
"

# Start logging services
echo "Starting Logging Services............"
rsyslogd 2>/dev/null

echo "
"

# Password for "root" user
echo "Set a password for the root user:
"
passwd root

echo "
"

echo "Cron Service is Starting............"
service cron start
service cron status

echo "
"

# CRONjob setup
CRONTAB_CONFIG() {
    touch /etc/cron.d/scripts

    echo "Frequency of the Scripts to run?

    Select an Option:
    1] Every minute (Live - recommended if using SSH transfer)
    2] Hourly (24 times a day)
    3] Every 8 hours (3 times a day)
    4] Daily (once a day)
    "

    read CHOICE

    case "$CHOICE" in
        (1)
            echo "Scripts will run every minute (but will be transfered every 3 minutes)
"
            echo "* * * * * $LOGFILES/master.sh
* * * * * $LOGFILES/usrpwd.sh
* * * * * $LOGFILES/passwordpolicy.sh
* * * * * $LOGFILES/geoiplocation.sh
* * * * * $LOGFILES/kibanamap.sh
* * * * * $LOGFILES/kmlmap.sh
* * * * * $LOGFILES/mail.sh
* * * * * $LOGFILES/transfer.sh

#EOL" > /etc/cron.d/scripts
        ;;
        (2)
            echo "Scripts will run hourly
"
            echo "54 * * * * $LOGFILES/master.sh
54 * * * * $LOGFILES/usrpwd.sh
57 * * * * $LOGFILES/passwordpolicy.sh
57 * * * * $LOGFILES/geoiplocation.sh
57 * * * * $LOGFILES/kibanamap.sh
57 * * * * $LOGFILES/kmlmap.sh
59 * * * * $LOGFILES/mail.sh
59 * * * * $LOGFILES/transfer.sh

#EOL" > /etc/cron.d/scripts
        ;;
        (3)
            echo "Scripts will run every 8 hours (3 times a day)
"
            echo "54 */8 * * * $LOGFILES/master.sh
54 */8 * * * $LOGFILES/usrpwd.sh
57 */8 * * * $LOGFILES/passwordpolicy.sh
57 */8 * * * $LOGFILES/geoiplocation.sh
57 */8 * * * $LOGFILES/kibanamap.sh
57 */8 * * * $LOGFILES/kmlmap.sh
59 */8 * * * $LOGFILES/mail.sh
59 */8 * * * $LOGFILES/transfer.sh

#EOL" > /etc/cron.d/scripts
        ;;
        (4)
            echo "Scripts will run daily (once a day)
"
            echo "54 23 * * * $LOGFILES/master.sh
54 23 * * * $LOGFILES/usrpwd.sh
57 23 * * * $LOGFILES/passwordpolicy.sh
57 23 * * * $LOGFILES/geoiplocation.sh
57 23 * * * $LOGFILES/kibanamap.sh
57 23 * * * $LOGFILES/kmlmap.sh
59 23 * * * $LOGFILES/mail.sh
59 23 * * * $LOGFILES/transfer.sh

#EOL" > /etc/cron.d/scripts
        ;;
        *)
            echo "Enter a valid option. Exited program with code: 3"
        ;;
    esac

    chmod 0644 /etc/cron.d/scripts
    crontab /etc/cron.d/scripts
    echo "Crontab has been configured successfully!
"
}

CRONTAB_CONFIG

echo "Restarting Cron Service............"
service cron restart
service cron status
echo "
"

# Configure SSH Transfer
read -p "Do you want to configure SSH transfer? (Y/n): " choice

if [[ $choice == "yes" || $choice == "Y" || $choice == "y" ]]; then

    echo "Generating Keys"
    ssh-keygen

    echo "Keys generated Successfully"

    echo "
Enter the username of the remote SSH machine"
    read REMOTEUSER
    sed -i "s/^# REMOTEUSER=/REMOTEUSER=$REMOTEUSER/" "$LOGFILES/transfer.sh"

    echo "
Enter the IP Address of the remote SSH machine"
    read REMOTEIP
    sed -i "s/^# REMOTEIP=/REMOTEIP=$REMOTEIP/" "$LOGFILES/transfer.sh"

    echo "
Enter the SSH port of the remote SSH machine"
    read REMOTEPORT
    sed -i "s/^# REMOTEPORT=/REMOTEPORT=$REMOTEPORT/" "$LOGFILES/transfer.sh"

    echo "
Enter the remote path to store logs"
    read REMOTEPATH
    sed -i "s|^# REMOTEPATH=|REMOTEPATH=$REMOTEPATH|" "$LOGFILES/transfer.sh"

    echo "Uploading Key to Remote Server...."
    ssh-copy-id -p $REMOTEPORT $REMOTEUSER@$REMOTEIP
    ssh $REMOTEUSER@$REMOTEIP -p $REMOTEPORT "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"

    echo "SSH has been configured successfully"

elif [[ $choice == "no" || $choice == "N" || $choice == "n" ]]; then
    echo "W: SSH is not configured"
else
    echo "Invalid choice. Please enter 'yes', or 'no'."
fi


# Configure Mail Transfer
read -p "Do you want to configure email transfer? (Y/n): " choice

if [[ $choice == "yes" || $choice == "Y" || $choice == "y" ]]; then

    # Generate a .env file for mail service:

    touch /var/log/dnsrout/.env

    echo "Enter the Correspondent's EMAIL Address"
    read EMAIL_ADDR
    echo "
Enter the Password for the given EMAIL Address"
    read -s EMAIL_PASS
    echo "
Enter the First Recipient's EMAIL Address"
    read EMAIL_REC1
    echo "
Enter the Second Recipient's EMAIL Address"
    read EMAIL_REC2

    echo "EMAIL_ADDR=$EMAIL_ADDR
    EMAIL_PASS=$EMAIL_PASS
    EMAIL_REC1=$EMAIL_REC1
    EMAIL_REC2=$EMAIL_REC2" >> /var/log/dnsrout/.env

    echo "Email has been configured successfully"

elif [[ $choice == "no" || $choice == "N" || $choice == "n" ]]; then
    echo "W: Email is not configured"
else
    echo "Invalid choice. Please enter 'yes', or 'no'."
fi


echo "

HoneyTrack has been setup and you're good to go!
"
