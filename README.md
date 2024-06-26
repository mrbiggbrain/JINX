# JINX

JINX is a modern imaging tool designed to install Windows operating systems and automate their setup. It is written in PowerShell and uses tools built into the windows operating system to install and deploy WIM files. 

## Project Goals
The goal of this project is to produce a fast, customizable, and easy windows imaging workflow. It will eventually aim to reproduce the features of Microsoft Deployment Toolkit but written for modern needs in a modern language. 

JINX does not itself provide a wizard to configure the tool but uses simple JSON files. We leave it up to other tools to generate these configs for the tool to consume. We plan to provide a config generation wizard in the future in both a PowerShell script and GUI tool. In addition a basic web service is planned to allow for fetching the config. 

The overall approach is that **you** do the planning and **JINX** does the deploying. We leave it up to you how that planning and config gets generated. 

## Project Status
JINX is in early ALPHA stages of development. The curent status allows running from WindowsPE to perform the following:
- Partition and Format Installation Drive.
- Install Windows WIM Images.
- Inject Drivers based on Hardware.
- Generate an Unattend.xml file.

Work on the project is in two parts currently:

### Overhaul Configuration
The project currently has a basic configuration system using a JSON file. I am in the process of examining the best system to use for expressing the desired installation process. Things are very likely to break as we change the settings used and get the config system to a good place. 

### Software Installation
We are writing a simple software installation process that will occour after the PC reboots and completes it's initial OS install and skips the OOBE. This will allow you to install software, run scripts, and customize the system further. 

## Future Features
Here are some of the long term goals for the project. 

### Web Based Distribution
A long term goal for the project is to support web based distribution. This includes:
- Fetching files (Images, Software, Drivers, Etc) from the Web (S3/HTTPS/Etc)
- Fetching configs from the web via HTTP(S)

### Windows Updates
I am in the proccess of writing scripts to automate the installation of Windows Updates durring the imaging process. This will enable you to install updates automatically as PCs are imaged. 

