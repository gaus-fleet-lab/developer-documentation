# GAUS Concepts

There are a few concepts that you need to get acquainted with before setting up your first product in GAUS.

Parameters and update-type are used as essential parts the product definition.
Parameters and update-types are used to group devices into logical sets that can be operated on, e.g. make an update only for a certain set of devices.

## Parameters

Parameters are used to distinguish your individual devices from each other and there are only one parameter that is mandatory, Device ID. Device ID can be either something that already exists in your product like:
* mac address
* serial-number

If your device does not have a unique identifier GAUS will assign one for it when the device does the registration. This parameter is mandatory when using the device api.

The recommendation is to have at least a few more parameters that can be used for device selection. Example on parameters can be:
* Location
* Country
* Hardware revision
* Variant
* Customization
* device-type (beta, standard, test, ...)

## update-type
Update-type are used for the parts in the device that can be updated, and all devices must have at least one updatable software component. Of course, it is not limited to only one updatable software component, there can several different types for each device. e.g.
* Firmware 
* OS
* Customization-file
* Localization-file
* Modem software
* resource-file
* applications
* configuration-file


## Usage of parameters and update-types
A device that is connected to GAUS will typically periodically exercise the check-for-update api-call, except for the authentication parameters only the device id and at least one update-type is mandatory but since both parameters and update-types can be used for distribution and analysis the recommendation is to let all api calls contain the parameters and update-type versions so that you will be able to do the logical groups you want to later when distributing software updates to your devices.
Examples of different types of update scenarios:
* Canary
* beta users
* Nightly test
* Build on commit test
* distribution of a new modem to only devices with a certain hardware revision.
* Distribution of an application/resource file to devices with at least a certain OS version
