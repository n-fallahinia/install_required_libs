#!/bin/bash

#===============================================================================#
# This script installs all the required libraries and their dependencies for the 
# fingernail imaging calibration software 
# Navid Fallahinia
# Bio-Robotics Lab
#===============================================================================#

SOFTWARE_VERSION="latest"	     
INSTALL_FLTK=false  # Install FLTK to handle the graphical GUI
INSTALL_COMEDI=false  # Install comedilib to communicate with the DAQ card
INSTALL_CAMERA=true  # Install PyCapture for the Flea camera
INSTALL_DC1394=false  # Install IEEE 1394 for the camera
INSTALL_OPENCV=false  # Install Opencv2 for image resize

INSTALL_DEPENDENCIES=false   # Install dependencies with apt (recommended)

# Set the path location where you want the libs created:
WORKSPACE_PATH="$HOME/opt"

# You shouldn't need to edit below this line
#===============================================================================#

#-------------------------------------------------------------------------------#
# Create the opt workspace                                                      #
#-------------------------------------------------------------------------------#
if [ -d "$WORKSPACE_PATH" ] ; then
    echo -e "\nThe directory $WORKSPACE_PATH already exists.\n"
else
    echo -e -n "\nMaking directory $WORKSPACE_PATH..."
	mkdir -p ${WORKSPACE_PATH}
    echo -e " Done!\n"
fi

cd ${WORKSPACE_PATH}

#-------------------------------------------------------------------------------#
# Install dependencies                                                          #
#-------------------------------------------------------------------------------#
if [ "$INSTALL_DEPENDENCIES" = true ] ; then
	echo -e "Installing required libraries...\n"
    PACKAGES+=" autoconf swig libtool bison zlib1g-dev flex"
    PACKAGES+=" libx11-dev libglu1-mesa-dev subversion libasound2-dev libxft-dev"
    PACKAGES+=" libraw1394-11 libgtkmm-2.4-dev libglademm-2.4-dev libgtkglextmm-x11-1.2-dev libusb-1.0-0"
    PACKAGES+=" libusb-1.0-0-dev"
    sudo apt update
  	sudo apt install $PACKAGES
else
	echo -e "No library will be installed\n"
fi

#-------------------------------------------------------------------------------#
# Install the libraries and clone the repositories at the necessary branches    #
#-------------------------------------------------------------------------------#
if [ "$INSTALL_FLTK" = true ] ; then
	git clone https://github.com/fltk/fltk.git
	cd ${WORKSPACE_PATH}/fltk
	NOCONFIGURE=1 ./autogen.sh
	./configure
	make
	sudo make install
	echo -e "FLTK installed successfully\n" 
fi

if [ "$INSTALL_COMEDI" = true ] ; then
	git clone https://github.com/Linux-Comedi/comedilib.git	
	cd ${WORKSPACE_PATH}/comedilib
	./autogen.sh
	./configure --with-udev-hotplug=/lib --sysconfdir=/etc
	make
	sudo make install
	echo -e "COMEDILIB installed successfully\n" 
fi

if [ "$INSTALL_CAMERA" = true ] ; then
	git clone https://github.com/RhobanDeps/flycapture.git
	cd ${WORKSPACE_PATH}/flycapture
	sudo sh install_flycapture.sh
	echo -e "PyCapture installed successfully\n" 
fi

if [ "$INSTALL_DC1394" = true ] ; then
	git clone https://github.com/fralik/libdc1394-flir.git
	cd ${WORKSPACE_PATH}/libdc1394-flir/libdc1394
	autoreconf -i -s
	./configure
	# make
	# sudo make install
	echo -e "DC1394 installed successfully\n" 
fi

