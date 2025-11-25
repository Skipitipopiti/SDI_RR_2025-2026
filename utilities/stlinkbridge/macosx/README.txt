*************************************************************************
*
* README file for stlinkbridge utility - MacOSX version
*
*************************************************************************

* Content:

This package contains three files:

a) stlinkbridge - Application executable
b) libSTLinkUSBDriver.dylib - Shared library used to control STLINK bridges
c) libusb-1.0.0.dylib - Shared library for basic USB userspace programming

* Installation:

- Copy stlinkbridge executable into a place where it is in the executable path.
  A reasonable place is /usr/local/bin, but it is not mandatory.
- Copy libSTLinkUSBDriver.dylib and libusb-1.0.0.dylib to a directory included
  in the library search path. A reasonable place is /usr/local/lib.

To check for correct installation, just open a new command shell (Terminal), and
start the command:

	stlinkbrige

If everything is ok, a brief help message will be displayed, without errors.

* Usage:

The intended usage of this tool is as ancillary executable for the
VirtLAB-UI Java application. Anyway, it can be used as a standalone terminal
command, if needed.

If started without arguments, a brief message is output, describing usage:

Usage: stlinkbridge mode
    where mode can be:
    m: master MCU connected to STLink bridge
    u: user MCU connected to STLink bridge
    x: no MCU connected to STLink bridge

As above described, the command accept exactly one command line argument,
and the STLink bridge included on the VirtLAB board will be configured
accordingly.
The command can be executed as many times as required.

