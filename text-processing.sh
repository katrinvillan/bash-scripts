#!/usr/bin/env bash

    #Initialize pattern and directory path
    SOURCE_DIR="/home/phoenixmgr/tmp/evaluate/AnalysisFiles"
    RESULT_DIR="/home/phoenixmgr/tmp/evaluate/AnalysisFilesResult"
    LOG="/home/phoenixmgr/tmp/evaluate/logs"
    LOG_FILE=$LOG/tmp.log
    pattern="M_10_File"

    #Create result directory and delete previous log
    mkdir -p $RESULT_DIR
    rm -f $LOG_FILE

    #Go to source directory
    cd $SOURCE_DIR

    #Loop through source directory, access files that starts with M and ends with .dat
    for file in "$SOURCE_DIR"/M_*_10_*.dat; do
    line_number=0
    
    #Read the tenth line from the file
    string_result=($(awk '{if(NR==2) print $1}' $file | tr -d \\r))

    #If the tenth line matches the pattern, proceed to next process
    if [ "$string_result" == "$pattern" ]; then
       echo $file >> $LOG_FILE

       #Write the portion of the file after the matching string to tmp.txt
       awk '/\[EQUIPMENT\]/,0' $file > tmp.txt
       count_fail=($(wc -l tmp.txt))
              
       #If tmp.txt has a result, proceed to next process
       if [ $count_fail -gt 1 ]; then

           #Count the lines between two strings
           count_NG=($(awk '/\[HOST\]/,/\[ALL\]/' $file | wc -l))
           
           #It should find at least four lines to proceed. If count is greater than three, proceed to next operations
           if [ $count_NG -lt 3 ]; then

               #Loop through tmp.txt file, get every nth line and print out to tmp2.txt 
               while read line; do
                   
                   #Increment the counter. Next conditions rely to this counter - the line is printed only when the counter reaches 1 after which the counter is reset to 0.
                   line_number=$((line_number+1))

                   #Skip the line that includes the header [], reset the count to 0
                   if [[ "$line" == *"["* ]]; then
                       line_number=0     
                   fi
               
                   #Get every first line and print out to tmp2.txt
                   if [ $line_number -eq 1 ]; then
                      echo "$line" >> tmp2.txt
                   fi

                   #If line_number is equal to 4, reset the count to 0 (process set of four lines)
                   if [ $line_number -eq 4 ]; then
                       line_number=0
                   fi
               done < tmp.txt
           
               #Sort and count number of occurrence of lines. Print out the result to tmp3.txt
               awk -F '\t' '{print $1}' tmp2.txt | sort | uniq -c | sort -nr > tmp3.txt
               
               echo "    >> Items to insert:" >> $LOG_FILE
               
               #Loop through tmp3.txt file. 
               while read line; do
                   #Read each column into separate variables (white space characters will be used to split each line). 
                   item_col2=($(awk '{print $2}' <<< $line | tr -d \\r))
                   item_col1_tmp=($(awk '{print $1}' <<< $line | tr -d \\r))

                   #Add leading zeroes before item_col1_tmp. Ex.: 5 -> 00005
                   item_col1=$(printf "%05d" $item_col1_tmp)
                       
                   if [[ "$item_col2" != "" ]]; then
                       echo "$item_col2" >> tmp4.txt
                       echo "$item_col1" >> tmp4.txt

                       echo "       $item_col2" >> $LOG_FILE
                       echo "       $item_col1" >> $LOG_FILE
                   fi
               done < tmp3.txt
               
               #Extract filename
               file_name=${file##*/}
               
               #Insert the content of tmp4.txt after a certain string in the file. Save the result using a new file.
               sed -e '/\[HOST\]/r tmp4.txt' $file >> $RESULT_DIR/$file_name
               
               
               rm -f tmp3.txt
               rm -f tmp4.txt
           fi
           rm -f tmp2.txt
       fi 
    fi
    rm -f tmp.txt    
    done

    
    cp "$LOG_FILE" "$LOG/$(date '+%Y%m%d')_$(date '+%H%M%S')_text-processing.sh.log"


