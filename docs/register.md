# Register

When register the device, the device will use the product secret and the access key to authenticate and get back
an unique device secert and access key that will be used for the device entire life time.

The register can be done in different places:
* In factory - before flashing the device, factory could do a register and save the device unique key together with
 the firmware
* Manually - before the device is mounted, sold it, there can be a script that do the register and save down the
 device unique key into the device
* First start up - when the device start up for the firsta time, the device it self can to the register


## Step by step
* Read the "bootstrap.conf" and extract the product accessKey, secretKey and URL to the Gaus server

* Extract/create/retrieve the deviceId (Could be MAC address, serie-nummer or generated data)
  There is no check that the deviceId will be uniqe on the backend, meaning that you can register two devices
  with the same deviceId but the devices will get two unique deviceGUID.

* POST the to the register url with the deviceId, product accessKey and product secretKey

```javascript
/register
 
POST:
{
  "deviceId": "test-device-1",
  "productAuthParameters": {
    "accessKey": "d123d38cbdef8305678c73931c199bbb175e3fa92cbe3a89490a85ebf34165a5",
    "secretKey": "afb4efg8763ef3412acf563821bafb165431abe4d3a2e598ef132ab3e4ef"
  }
}
```
* If success, the GAUS will add the device and send back the default
 pollIntervalSeconds (for [check-for-update](../docs/check-for-update.md)) and the unique device accessKey and device secret that
 will be used for [authentication](../docs/authentication.md) 
```javascript
 
RESPONSE: 200 OK
{
  "pollIntervalSeconds": 12345,
  "deviceAuthParameters": {
    "accessKey": "2d2f4a237d433cafae6ca1e07cf6feda672211b679da244488c15c13fe762f8b",
    "secretKey": "e1827d3c4bc76a90ca43f28cec8a439ec04792729609321b7975ac99675fe4f7"
  }
}

```
