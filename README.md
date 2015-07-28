# Pyrrhotite vacancy ordering (kMC) #

This is a simple MATLAB program for simulating point defect migration in bulk pyrrhotite, Fe<sub>1-x</sub>S during a vacancy rearrangement transformation using kineitc Monte Carlo.
This code is supplementary information for the journal article **Diffusion-limited kinetics of the antiferromagnetic to ferrimagnetic λ-transition in Fe<sub>1-x</sub>S**, *Applied Physics Letters*, 106, 092402, 2015. DOI: [10.1063/1.4913201](http://dx.doi.org/10.1063/1.4913201)


Running
-----------

*  From within the MATLAB command window
  *  Navigate to the directory with the .m files within the MATLAB command window and run the program using `pht-kmc`
*  From the terminal
  *  Navigate to the directory with the .m files and run `matlab -nojvm -nodisplay -nosplash < pht-kmc.m`


 Output
 ----------
 The main output is a sequnce of `svd-*.mat` files. Each file has a snapshot of the grid in the `kg` variable, and the sequence of magnetic moment and wall-time (till the snapshot) in the 1-D arrays `mom` and `tim` respectively
 
 
 Running in parallel
 ----------
 
 *  If you use a parallel pool, reset the seed on the RNG for each process. Since the seed is derived from the current time, just update the `pause` command in each instance of the program. Something like `pause(my_rank)` will do.
 *  There are a couple of example scripts in the `parallel` folder required to set up a parallel run for TACC clusters using the [`launcher`](https://github.com/TACC/launcher) program
   *  For the default scripts to work, you will need to provide your own MATLAB license file
   
