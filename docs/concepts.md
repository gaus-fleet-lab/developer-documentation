# GAUS Concepts

There are a few concepts that you need to get acquainted with before setting up your first product in GAUS.

## Product
In GAUS, a product definition describe the device in two main parts:
* What the Device can rapport in for data that describe it self (parameters), ex: firmware-version
* Which part of the Device can be updated (update-type), ex: firmware, modem.

Parameters and update-types are used to group devices into logical sets that can be operated on, e.g. make an update only for a certain set of devices.

## Parameters
Two different types of parameters exists, one type used in device registration and another type used in all other device api calls.
This section describes the second type of parameters used in all device api calls except the registration call (for information regarding the registration, see [docs/register.md](../docs/register.md).

Parameters are used to distinguish your individual devices from each other 

The recommendation is to have at least a few parameters that can be used for device selection. Example on parameters can be:
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

If the device does not provide the update-type parameter (firmware-version), the backend will always return the "latest"
update.

## Usage of parameters and update-types
A device that is connected to GAUS will typically periodically exercise the check-for-update api-call, except for the authentication parameters, only (at least) one update-type is mandatory but since both parameters and update-types can be used for distribution and analysis the recommendation is to let all api calls contain the parameters and update-type versions so that you will be able to do the logical groups you want to later when distributing software updates to your devices.
Examples of different types of update scenarios:
* Canary
* beta users
* Nightly test
* Build on commit test
* distribution of a new modem to only devices with a certain hardware revision.
* Distribution of an application/resource file to devices with at least a certain OS version

Before the device api call is handled by the GAUS backend there will be a step with decorating the call with server-based parameters, they include device-id, device-guid, product-guid and other serverside parameters (x-gaus-???) so they can also be used when selecting your target, either when distributing updates or when analysing results from devices.
