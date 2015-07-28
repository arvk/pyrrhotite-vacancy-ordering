* The paramlist provided here runs 16 serial instances of the program (Taking up one node on TACC-Stampede)
* To set up the run, copy all the m files into a folder named '1' and copy it 16 times, naming each folder succesively from 1 to 16
* Change the `pause` statement in the pht-kmc.m files in each folder so that they are different from each other. This will generate a different seed for each instance 
* The submit script and both param files are outside the 16 folders. You need a MATLAB license file `license.txt` located in your home folder
