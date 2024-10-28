Analysis for the effects of ALAN and Ta for SOS/EOS
=====
Overview:
--
The analysis includes two part derive from Google Earth Engine (GEE) and Matlab platform. GEE is a cloud-based service that provides access to satellite imagery and geospatial datasets for planetary-scale analysis. Raw data can be retrieved from GEE, and the associated scripts for data processing are available with the link: https://code.earthengine.google.com/?accept_repo=users/lvvw66/ALAN_UHI_pheno. The codes provided above is about the statistical analysis of raw data using Matlab software.

System requirements:
--
Hardware requirements:

 A standard computer with enough RAM to support the in-memory operations is required for the installation and operations with Matlab platform.
Software requirements:
The Matlab 2022a install package is accessible on the website: https://www.mathworks.com/products/matlab.html.
Toolbox including:
Statistics and Machine Learning Toolbox
Mapping Toolbox
Curve Fitting Toolbox

Installation guide:
--
The details about Matlab installation and Toolbox management is accessible at：https://ww2.mathworks.cn/help/install/ug/install-products-with-internet-connection.html. 

Demo:
--
	These scripts are designed for attribution analysis and visualization of figures presented in the manuscript titled "Artificial light at night outweighs temperature in lengthening urban growing seasons." This Code folder provides codes of analysis for the example (New York) in ".m" type, and the data for the example is in Demo folder. 
	
Instruction for use:
--
·To download the data form Demo and code for Code.
·Include the data and code in one folder in your personal computer.
·The first step is read city list and tidy the raw data with ReadCityInfo.m and Tidy_pheno_ALAN_T.m.

