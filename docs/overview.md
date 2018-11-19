# GAUS client/backend overview

![overview](../pics/overview.png)

## Definitions

Name | Stored in Device | Table in backend | Description
----------------------------------------------------------
productAuthParameters.accessKey | bootstrap.conf            | bootstrapped value for access to on-boarding for a specific product
productAuthParameters.secretKey | bootstrap.conf            | bootstrapped value for access to on-boarding for a specific product
deviceId                        | (somewhere in the device) | A device id that is unique identifier for the device that the device implementer choose, it could be MAC address, serial number, ...
deviceGUID                      | Session memory            | Backend generated GUID for tracking the device.
deviceAuthParameters.accessKey  | device.data               | Unique value for device to access the authentication API
deviceAuthParameters.secretKey  | device.data               | Unique value for device to access the authentication API
productGUID                     | Session memory            | Backend generated Id to track the product.
token                           | Session memory            | Backend generated JWT token used to authenticate to the device API,
pollIntervalSeconds             | device.data               | Backend confiuration that will be sent to update client when on-bording and optinal when check-for-update.

