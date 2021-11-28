# Tinnitus-like "hallucinations" elicited by sensory deprivation in an entropy maximization recurrent neural network

This repository contains the code used in the paper Dotan A. and Shriki O., "Tinnitus-like "hallucinations" elicited by sensory deprivation in an entropy maximization recurrent neural network". _PLoS Computational Biology_. 

## Project structure

Each folder contains a full experiments set related to a single attenuation profile (see Fig. 2 in the paper). Within each folder, run `BatchSim.m` to run the simulations. Note that this will require a local `Results` folder to exist (if there isn't one, create an empty folder with that name within the attenuation profile's folder). 

For each attenuation profile, theere is a subfolder named `Figures_Scripts`. The file `CreateGraphs.m` can be used to produce all relevant (and other) figures. To be able to save the figures, [export_fig](https://www.mathworks.com/matlabcentral/fileexchange/23629-export_fig) is required, as well as a `Figures` folder within the attenuation profile's folder (if there isn't one, create an empty folder with that name). The folder `L1 regularization` is used in the same way to produce the supp. Figs. S5 and S6, and `no phase 2` is used for supp. Figs. S7-S10. Similarly, figures spanning several attenuation profiles can be produced form the `Figures_Scripts` folder located at the root folder. Again, a `Figures` folder should exist in the root folder (if there isn't one, create an empty folder with that name). 

Note that all figures' script make use of the results saved by the simulations. 

```
│
├─── README.md
│
├─── baseline                       # An attenuation profile's folder
│    ├─── BatchSim.m                # Run a simulations set
│    ├─── ...
│    │
│    ├─── Results                   # Create this folder (if necessary)
│    │    └─── ...
│    │
│    ├─── Figures                   # Create this folder (if necessary)
│    │    └─── ...
│    │
│    └─── Figures_Scripts
│        ├─── CreateGraphs.m        # Produce attenuation-profile-specific figures
│        └─── ...
│   
├─── ...
│
├─── Figures                        # Create this folder (if necessary)
│    └─── ...
│
└─── Figures_Scripts
     ├─── CreateGraphs.m            # Produce figures combining several attenuation profiles
     └─── ...
```


## Requirements
* Tested on Matlab R2020b.
* Figures' scripts use [export_fig](https://www.mathworks.com/matlabcentral/fileexchange/23629-export_fig) to save the figures. 

## Notes
* Typical runtimes are a 2-3 weeks per attenuation profile. 
* All scripts (especially the simulation scripts) save intermediate results, which may take up to a few GB of storage altogether. 
* All scripts will automatically restore their run from the last saved intermediate result, if there is any. 
* The `DisplayCurrent.m` scripts can be used for quick checkups on unfinished runs. 
* The main logic of the entropy maximization network is implemented in the `Infomax.m` class. The name "Infomax" was chosen to match the [original name](https://direct.mit.edu/neco/article/7/6/1129/5909/An-Information-Maximization-Approach-to-Blind) of the algorithm. 
* For self-compltibility reasons, regularization coefficients are incorrectly termed as "ridge" throughout the code. We do not have the time to fix this. 
* Due to the tight revisions schedule, fast results were generally prioritized over code quality. Thus, the overall structure of the code is terrible. If you have the time, feel free to improve it and submit a pull request. 
