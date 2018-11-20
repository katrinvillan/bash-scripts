# bash-scripts
A collection of useful bash scripts.

**email-html-format.sh** - accepts a csv file as argument and loops thought it to produce HTML table and sent it to email using "sendmail" command.

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites
* OS that supports Bash.
* If you are a Windows User, you may need to install a GNU tool which provide functionality similar to a Linux distribution on Windows.
  
  - [About Cygwin](https://www.cygwin.com/)
 
  - [Install Cygwin](https://www.cygwin.com/install.html) (you need to install its exim and email utilites)

### Installing

Clone the GIT repository using command:
```
$git clone https://github.com/katrinvillan/bash-scripts.git
```

## Running the tests

Go to the cloned directory:
```
$ cd bash-scripts
```

* **email-html-format.sh**

Run the following command to execute the script called "email-html-format.sh". It accepts the csv file "sample-email-source.csv" as argument. 
```
$ ./email-html-format.sh "sample-email-source.csv"
```
Sample output :

With Cygwin, you can view the results immediately in a text file (path : \var\spool).

## Built With
* gcc version 4.3.4 [gcc-4_3-branch revision 152973] (SUSE Linux)
* gcc version 4.4.6 20120305 (Red Hat 4.4.6-4) (GCC)

## Authors

* **Kat Villanueva**

Feel free to edit these scripts as needed, or use it unedited to test. Keep in mind that I have not tested them on every other Linux distribution available. I would love to hear your comments and I will happily look at any suggestions for new features or code fixes. 

