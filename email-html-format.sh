#!/bin/bash
 
    #function that sends a file to an email address using sendmail command.
    #parameters : 1-html table file, 2-email address , 3-email subject
    send_email () {                           
        now=`date '+%Y-%m-%d %H:%M:%S'`        
        if [ ! -f "$1" ]; then exit 1; fi
        
        (
            echo "To: $2"
            echo "Subject: $3"
            echo "Content-Type: text/html"
            echo "<HTML> <p>Date/Time : $now</p>"
           
            cat $1

            echo "</HTML>"
        ) | /usr/sbin/sendmail -t
    }

    #initialize variables. Create temp file
    FILE=$1
    BODY="/tmp/email-html-format.$$"
    EMAIL="user@domain.com" #multiple emails : type a comma to separate this address from the next email address
    SUBJECT="LIST OF HOSTS"

    #exit and return code 1 if FILE does not exist or is empty.
    if [ ! -f "$FILE" ] || [ ! -s "$FILE" ]; then exit 1; fi
  
    #create headers of the html table.
    echo "
          <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR=#000000>
              <TR>
                  <TH COLSPAN="5">
                      <FONT size='3'>$SUBJECT</FONT>
                  </TH>
              </TR>
              <TR BGCOLOR=#999999>
                  <FONT size='1' face='Consolas'>
                  <TH>Host Name</TH>
                  <TH>IP Address</TH>
                  <TH>MAC Address</TH>
                  <TH>User Name</TH>
                  <TH>Date</TH>
                  </FONT>
              </TR>
         " >> $BODY

    #loop through the csv file. Turn each comman separated line into html table row. 
    while IFS=, read -r host_name ip_address mac_address user_name date
    do   
        echo "<TR BGCOLOR=#ffffff>
                  <FONT size='1' face='Consolas'>
                  <TD ALIGN="CENTER">$host_name</TD>
                  <TD ALIGN="CENTER">$ip_address</TD>
                  <TD ALIGN="CENTER">$mac_address</TD>
                  <TD ALIGN="CENTER">$user_name</TD>
                  <TD ALIGN="CENTER" BGCOLOR=#fff5f2>$date</TD>
                  </FONT>
              </TR>
             " >> $BODY

    done < "$FILE"
 
    
    echo "  </TABLE>
            <p>This is an auto-generated email. Do not reply.</p>
         " >> $BODY

    #send the file BODY in mail using sendmail command.
    #args : html table file, email address , email subject
    send_email "$BODY" "$EMAIL" "$SUBJECT"

    rm -f $BODY

    exit 0 
 
