# HoneyTrack

"HoneyTrack" is a Honeypot built using Docker (Image used was Ubuntu 20.04), with help of Python and Bash Scripting. This tracks the SSH and Web Activity and sends it via Email to the intended person.

The payloads folder contains an application which is a Trojan, wherein if the Threat Actor executes the program, a series of payloads will trigger and will also be sent via mail to the intended recipient.

### Installation

Install Docker

sudo docker build -t local/honeytrack-ssh-vf-cloud:latest -f docker/Dockerfile .


For Installation procedure and working, please visit the [Wiki Section](https://github.com/aatharvauti/HoneyTrack/wiki) of this repository.

Made as a part of Academic Project by: Atharva Auti, Jay Makwana, Shrawani Pagar, and Vivek Mishra at Shah and Anchor Kutchhi Engineering College

Guides: Ms. Shwetambari Borade and Dr. Nilakshi Jain
