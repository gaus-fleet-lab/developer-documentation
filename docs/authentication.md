# Authentication

To be able to us the device API, the device need to authenticate it self. This is done by posting the device
unique access and secret to GAUS and get back a [JWT](https://jwt.io) token. This token has time to live date,
so when it expires, the device need to re-authenticate.


```javascript
/authenticate - POST
{
  "deviceAuthParameters": {
    "accessKey": "d123d38cbdef8305678c73931c199bbb175e3fa92cbe3a89490a85ebf34165a5",
    "secretKey": "afb4efg8763ef3412acf563821bafb165431abe4d3a2e598ef132ab3e4ef"
  }
}
```
The response include the deviceGUID and productGUID. The device need them to build up the URL for [check-for-update](../docs/check-for-update.md)
and [report](../docs/report.md). This three values should be store in the session memory and could always been retrieved by doing a new /authentication
```javascript
RESPONSE: OK
{
 "deviceGUID": "ed031364-07ec-4ef8-aa76-b3c56b4069a7",
 "productGUID": "681f244f-243c-4c29-9e73-b5ba55a284d4",
 "token": "eyJhbGciOiJSUzI1NiIsImtpZCI6Ijc4YjRjZjIzNjU2ZGMzOTUzNjRmMWI2YzAyOTA3NjkxZjJjZGZmZTEifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwic3ViIjoiMTEwNTAyMjUxMTU4OTIwMTQ3NzMyIiwiYXpwIjoiODI1MjQ5ODM1NjU5LXRlOHFnbDcwMWtnb25ub21ucDRzcXY3ZXJodTEyMTFzLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiZW1haWwiOiJwcmFiYXRoQHdzbzIuY29tIiwiYXRfaGFzaCI6InpmODZ2TnVsc0xCOGdGYXFSd2R6WWciLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXVkIjoiODI1MjQ5ODM1NjU5LXRlOHFnbDcwMWtnb25ub21ucDRzcXY3ZXJodTEyMTFzLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiaGQiOiJ3c28yLmNvbSIsImlhdCI6MTQwMTkwODI3MSwiZXhwIjoxNDAxOTEyMTcxfQ.TVKv-pdyvk2gW8sGsCbsnkqsrS0T-H00xnY6ETkIfgIxfotvFn5IwKm3xyBMpy0FFe0Rb5Ht8AEJV6PdWyxz8rMgX2HROWqSo_RfEfUpBb4iOsq4W28KftW5H0IA44VmNZ6zU4YTqPSt4TPhyFC9fP2D_Hg7JQozpQRUfbWTJI"
}
```

A example flow in the code could be something like this:
```javascript
// Device starts up
register = readFromDisc()
if (register === undefined) {
    register = doRegister(bootstrap.secret, bootstrap.access, deviceId)
}

while(1) {
    res = doCheckForUpdate(authenticate.token, authenticate.productGUID, authenticate.deviceGUID)
    if (res.httpStatus === '401') {
        authenticate = doAuthenticate(register.access, register.secret)
        continue
    } else if (res.httpStatus === '200') {
        // Handle updates
    } else {
        // Handle error
    }
    sleep register.poolIntervallSeconds
}

```

## JWT token

The JWT token that is returned [rfc7519](https://tools.ietf.org/html/rfc7519) from the authentication call has this structure:

```javascript
{
  "sub": "440a7da3-0505-4528-9920-1e47c0e06c11:3b043c10-687c-49fe-ab20-a289197478ae",  //Subject
  "aud": "",
  "jti": "85d6f550-85fd-4135-b153-2b631b961c4f",    // JWT ID
  "pi": "440a7da3-0505-4528-9920-1e47c0e06c11",     // GAUS added field: ProductGUID
  "di": "3b043c10-687c-49fe-ab20-a289197478ae",     // GAUS added field: DeviceGUID
  "iat": 1541073637,                                // Issued At
  "exp": 1541077237                                 // Expiration Time
}
```

For more details of the different fields, see the iso standard [documentation](https://tools.ietf.org/html/rfc7519#section-4.1)

The productGUID and deviceGUID exist both in the JWT token and in the return JSON for easier extraction for the client.

The GAUS JWT token grant access to:
```javascript
    'GET', `/device/${productGUID}/${deviceGUID}/*`
    'POST', `/device/${productGUID}/${deviceGUID}/*    
```
