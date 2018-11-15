## Getting Started

You need to get invitation mail from GAUS with user credentials. 
(If missing, [send mail](mailto:gaus@sonymobile.com) for support)

### Create product

First step is to create a Product from the Administration UI. 

* Login to GAUS administration UI.

* Follow instructions how to “Add Product” from the User Guide.
 User Guide is available in the upper bar in the Administration UI.

* When Product is created will you get a product accessKey and secretKey to be used for on-
boarding devices. Save the those values in a file called bootstrap.conf.
 
In bootstrap.conf file, add also:
* Device ID - device specific and could be for example MAC, series number or other id:s.
* GAUS URL - deivice API URL

```
cat <<EOT >> bootstrap.conf
 GAUS_URL=https://ZZZ.gaus.sonymobile.com
 PRODUCT_ACCESS_KEY=XXX
 PRODUCT_SECRET_KEY=YYY
 DEVICEID=AAA
 EOT
```

### Register device

The first step for a device is to use the product access and secrets to register.
When the device has register it will get a device unique access and secrets that
is needed for authentication.  

For more information: [overview picture](../docs/overview.md)
```
source bootstrap.conf
cat > product.json <<EOF
{
  "productAuthParameters": {
    "accessKey": "$PRODUCT_ACCESS_KEY",
    "secretKey": "$PRODUCT_SECRET_KEY"
  },
  "deviceId": "$DEVICEID"
}
EOF
RESULT=$(curl -X POST -d @product.json $GAUS_URL/register -s -H "Content-Type: application/json; charset=utf-8")
echo $RESULT
```
See full bash code [register.sh](curl/register.sh)

Save the unique device access and secret in a file called: device.data

For more information: [authentication](../docs/authentication.md)

### Authenticate
Before using the check-for-update or the report API, the device need to authenticate it self vi the authenticate API.
The device will use the creedentials that was saved down from the register. When the device has registered it will
get a uniqe JWT token that is used for access the check-for-update and report API. For an overview see [overview picture](TODO)

```
curl -X POST \
     -d "{ \"deviceAuthParameters\": { \"accessKey\": \"$DEVICE_ACCESS_KEY\", \"secretKey\": \"$DEVICE_SECRET_KEY\" }}" \
     -H \"Content-Type: application/json\" \
     $GAUS_URL/authenticate"

```
See the full bash code [check-for-update.sh](curl/check-for-update.sh)

Save the TOKEN, PRODUCT_GUID and DEVICE_GUID in a session object.

For more information: [authentication](../docs/authentication.md)
### Check for update

Now the device can start "check for update" by presenting it self for the backend. Currently firmware-version
mandatory as parameter, but it free to add other parameters as for example "location".
Use the TOKEN and the PRODUCT_GUID and DEVICE_GUID from the authentication call.

```
curl -X GET \
     -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/json" \
     "$GAUS_URL/device/$PRODUCT_GUID/$DEVICE_GUID/check-for-updates?firmware-version=1.0.0&location=swe"
```
See the full bash code [check-for-update.sh](curl/check-for-update.sh)

This call will return eiter a empty json object if there where no update or a uppdate manifest.

For more information: [check-for-update](../docs/report.md)
