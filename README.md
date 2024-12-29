SIPP：A single-image processing platform

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

There are a large number of image enhancement methods in the literature. Many of them publicly provide the demos or the source codes. One of my researches require a visual comparison of them. However, I have not found a tool that integrates the various demos or source codes to meet my requirement. Therefore, I designed SIPP for the convenience of my own work. 

SIPP integrates about 30 image enhancement methods, and more single image processing methods will be added in the future. SIPP has the following features:

Graphical User Interface (GUI)
    SIPP provides a simple and straightforward GUI. User can select a method to run from the menu. The parameters of these methods can be manually changed on a dialog window.

Plug-in based architecture
    SIPP adopt a plugin architecture. Developers can easily install new plug-ins in SIPP by writing a single interface file and placing it in the filters folder. No changes are required to the source codes of SIPP.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Environment
    SIPP is developed on Matlab 2018a, but I believe it can run on Matlab 2014 or later.

Usage
    Launch Matlab, install sipp and its subfolders in Matlab paths, then type sipp in the Command window, press Enter.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

For developers
    I would be very grateful if you were interested in improving SIPP.
    There are two things to pay attention to when developing a sipp plug-in:
    1)The interface file.
    Each plug-in for a single-image processing method should have an interface file with a function prefix ‘spl_’ to be loaded by SIPP. Please take the spl_*.m file in each subdirectory of filters folder as the example. 
    2) The plug-in folder
    All plug-ins should have their own one-level subfolder within the folder called filters. I did not design recursive access to the plug-ins, so only one-level subdirectory for each plug-in is allowed.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
Copyright
    SIPP is for academic purposes only. 
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Version history:

0.5: Dec 2024, Initial version. Initial release.
     Author: Tian Pu
             IDIPLab, School of Information and Communication Engineering
             University of Electronic Science and Technology of China.
     Tian Pu wrote the main program of SIPP. The source codes of each image 
     processing method are written by its authors unless specifically indicated 
     in its m-file.
