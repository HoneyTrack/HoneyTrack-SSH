#!/usr/bin/python
from dotenv import load_dotenv
import os
from os import path
import smtplib
from email.message import EmailMessage

load_dotenv()
# VENV Importing
EMAIL_ADDR = os.getenv('EMAIL_ADDR')
EMAIL_PASS = os.getenv('EMAIL_PASS')
EMAIL_REC1 = os.getenv('EMAIL_REC1')
EMAIL_REC2 = os.getenv('EMAIL_REC2')

contacts = [EMAIL_REC1, EMAIL_REC2]
msg = EmailMessage()
msg['Subject'] = 'ALERT! Someone is trying to access your honeypot'
msg['From'] = EMAIL_ADDR
msg['To'] = contacts
msg.set_content('Check the attached log files. Also check the generated Password Policy and Firewall Policy.')

# List of log files to attach
log_files = [
    '/var/log/auth.log',
    '/var/log/dnsrout/master.log',
    '/var/log/dnsrout/usrpwd.log',
    '/var/log/dnsrout/passwordpolicy.txt',
    '/var/log/dnsrout/firewall.sh',
    '/var/log/dnsrout/ip-ad.txt'
]

# Iterate through the list of log files
for log_file in log_files:
    if os.path.exists(log_file):
        with open(log_file, 'rb') as f:
            file_data = f.read()
            file_name = os.path.basename(log_file)
        # Add attachment to the email
        msg.add_attachment(file_data, maintype='text', subtype='plain', filename=file_name)


with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp: # prod
    smtp.login(EMAIL_ADDR, EMAIL_PASS)
    smtp.send_message(msg)
#    smtp.close()
