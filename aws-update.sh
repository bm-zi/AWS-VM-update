#!/bin/bash

   # Author: bm-zi
   # This script updates the website(/var/www/html/)on an aws instance,
   # from the origin local backup directory     


   # Remote server ip address
   ip='Your_aws_ip_address'
   
   localdir='Your_origin_local_directory_with_website_backup'
   remotedir="ec2-user@$ip:/var/www/html/" 
   permFile='Path_to_key_file_file.pem'
      
   # Log all outputs in the same directory as this running script 
   DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
   log_file="$DIR/backup.log"
   
   cat /dev/null > $log_file
   clear

   # Print the outputs on the screen as well as writes them into a file
   exec >> >(tee -a $log_file)
   exec 2>&1
   
   echo	"_________________________"
   echo 
   echo "Recent 10 modified files:"
   echo "_________________________"

   find $localdir -type f | xargs stat --format '%Y :%y %n' 2>/dev/null | sort -nr | cut -d: -f2- | head -10

cat << EndOfMessage
    ______________________
   |                      |
   | Site Update started! |
   |______________________|

EndOfMessage


   rsync --recursive --archive --verbose --human-readable -e "ssh -i $permFile" $localdir $remotedir

cat << EndOfMessage
    _________________________
   |                         |
   | Site Update Compeleted! |
   |_________________________|

EndOfMessage
