# Developer documentation for GAUS client

For more information what GAUS is, check out [this](https://gaus.incubation.io/)


This documentation will describe how to:
* Getting started with dummy Curl client
* Connect a device to GAUS [TODO Link]()
* Get a update from GAUS [TODO Link]()
* Send metrics/events to GAUS [TODO Link]()

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

For more information see [overview picture](TODO)
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
Save the unique device access and secret in a file called: device.data
```
cat <<EOT >> device.data
DEVICE_ACCESS_KEY=$DEVICE_ACCESS_KEY
DEVICE_SECRET_KEY=$DEVICE_SECRET_KEY
GAUS_URL=$GAUS_URL
EOT
```

See full bash code [register.sh](curl/register.sh)

### Check for update

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
