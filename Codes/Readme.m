% 
% =========================================================================
% README: Code and Data Repository
% =========================================================================
% 
% This repository contains the MATLAB scripts and processed data required
% to reproduce the analyses and figures presented in the manuscript,
% including the supplementary figures.
% 
% -------------------------------------------------------------------------
% 1. Getting Started
% -------------------------------------------------------------------------
% Before running any analysis or figure-generation script, please run
% this README.m file first to add the required directories to the MATLAB
% path.
% 
% The following directories will be added automatically:
% - Mat_files: Contains processed data files required for figure generation.
% - beeswarm: Contains the beeswarm function used to visualize individual
%   subject data points.
% 
% -------------------------------------------------------------------------
% 2. Data Availability
% -------------------------------------------------------------------------
% The processed data required to reproduce the manuscript figures,
% supplementary figures, and corresponding statistical analyses are
% provided in this repository.
% 
% 
% -------------------------------------------------------------------------
% 3. Figure Generation
% -------------------------------------------------------------------------
% MATLAB plotting scripts are provided for the data-driven figures in
% the main manuscript and Supplementary Information.
% 
% Please note the following exceptions:
% - MATLAB scripts are not provided for Figures 1a-c, 2a, 3a, 4a, 4c,
%   5a, and 5b, as these panels were not generated using MATLAB
%   (e.g., conceptual diagrams, experimental paradigms, or illustrations
%   created using other vector graphics software).
% 
% -------------------------------------------------------------------------
% 4. Custom Functions
% -------------------------------------------------------------------------
%   Get_Mahalanobis_Distance.m and Plot_Time_Course.m are custom analysis
%   scripts provided to illustrate the computational procedures used
%   in our study.
% 
% - Get_Mahalanobis_Distance.m:
%   Contains the core analysis procedure for calculating Mahalanobis
%   distances in Experiment 2 (MEG). 
% 
% - Plot_Time_Course.m:
%   A custom-built interactive MATLAB GUI for visualizing the time-course
%   results presented in Figures 3f, 3g, and 4d.
%   The tool requires user interaction through the GUI to select and
%   configure the data for visualization, rather than running as a
%   fully automated script. 
% 
%   These custom analysis scripts require additional source-reconstructed
%   MEG data derived from the raw data using the Brainstorm toolbox.
%   These data are not currently included in the repository.
% 
%   We will make every effort to remove all personally identifiable
%   subject information and upload the corresponding raw MEG data to
%   the repository if the manuscript is accepted for publication.
% =========================================================================
% 
% Thank you for your interest in our work and for taking the time
% to explore our code repository! We hope you find these resources useful.


%% --- Add required directories to MATLAB path ---

% Get the directory containing this README.m file
repo_dir = fileparts(mfilename('fullpath'));

% Add Mat_files directory
addpath(fullfile(repo_dir, 'Mat_files'));

% Add beeswarm directory
addpath(fullfile(repo_dir, 'beeswarm'));

fprintf('Repository paths successfully added to MATLAB.\n');
fprintf('You can now run the figure-generation scripts.\n');

% =========================================================================
