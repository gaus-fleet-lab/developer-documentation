# Check for update

The check-for-update API is a polling api where the device will ask for updates. If there is an update, GAUS will
return that in an update manifest.

**Prerequisites:** The device has done an [authentication](../docs/authentication.md) call and retrieved a valid Token, productGUID and
deviceGUID

The device will present itself in the check-for-update API with the help of "query-parameters" that are defined
in the product that the device belongs to. See [concepts](../docs/concepts.md) for more information.

## Check-for-updates (No update)
```javascript
 Authorization: Bearer ${token}
 GET: /device/${productGUID}/${deviceGUID}/check-for-updates?firmware-version=1.0.0[&query-parameter-name=query-parameter-value]* - GET
 
 RESPONSE: 200 OK
 {
   "updates": []
 }
```

## Check-for-updates (Update hit, type file)
Note that there can be more then one update, but max one update per updateType. 
```javascript
 Authorization: Bearer ${token}
 GET: /device/${productGUID}/${deviceGUID}/check-for-updates?firmware-version=1.0.0[&query-parameter-name=query-parameter-value]* - GET
 
 RESPONSE: 200 OK
 {
  "updates": [
   {
    "metadata": {                                        // Zero to many Key/value pairs (only strings) decided by customers.
      "certificate": "forester_test",
      "digestType": "sha256",
      "signatureBase64": "CesI2u/zNEw...eBOda17NQdFa5WcspvcQnXEOB8evQE5Wf+fyYiw=",
      "toSha256": "82810805b842eb703b18392dcc9499cb408e1edf3822ae56fea2ef642c72d3a7"
    },                     
    "size": 5851822,                                     // Size in byte 
    "updateType": "firmware",                            // Defining typ of the update, example modem, firmware, config
    "packageType": "file",                               // If "file", then there exists, md5, downloadUrl, size
    "md5": "a52689fe5807c5cc52bce2f15eb438f2",           // This will be in HEX
    "updateId": "7b6128a7-c60c-4cd1-bf13-af1c60ff9e8e",  // This id is used to report status
    "version": "1.0.2",                                  // Version of this update
    "downloadUrl": "https://<your-subdomain>.gaus.sonymobile.com/files/950b53e4-1255-43cb-b49f-2dbde6acc595/f419b778-1014-45c1-bd57-441793d96fed"
   },
  {...} // Zero or One update per update type.
  ]
 }
```
