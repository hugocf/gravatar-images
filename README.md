Usage: gravatar-images.sh [options] emailsfile

    -a value    size for the avatar image [200]
    -q value    size for the QR code image [300]
    -h          this usage help text
    
    emailsfile  plain text file with only 1 email address per line [emails.txt]

This script iterates through the list of emails in a files, one per line, and
downloads from the Gravatar service (http://www.gravatar.com) their 
corresponding avatar images and QR codes (with a link to the Gravatar profile)

If a parameter is not supplied in the command line, the script prompts for 
confirmation of the default value, which means that in most cases you simply 
need to run the script 'as is':
    gravatar-images.sh

Example:
    gravatar-images.sh -a 100 -q 100 emails.txt
