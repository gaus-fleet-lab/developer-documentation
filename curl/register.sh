#!/bin/bash -ex

# Do a register of a device and save the output in the file: ./device.data
# Require curl and jq (sudo apt-get install curl jq)

if [ -f "$1" ]; then
  source $1
else
  echo "Usage: ./register.sh [bootstrap.conf] \n"
  exit 1
fi

cat > product.json <<EOF
{
  "productAuthParameters": {
    "accessKey": "$PRODUCT_ACCESS_KEY",
    "secretKey": "$PRODUCT_SECRET_KEY"
  },
  "deviceId": "$DEVICEID"
}
EOF
RESULT=$(curl -X POST -d @product.json $GAUS_URL/register -s -H "Content-Type: application/json")
rm ./product.json
DEVICE_ACCESS_KEY=$(echo $RESULT | jq .deviceAuthParameters.accessKey)
DEVICE_SECRET_KEY=$(echo $RESULT | jq .deviceAuthParameters.secretKey)

cat > device.data <<EOF
DEVICEID=$DEVICEID
DEVICE_ACCESS_KEY=$DEVICE_ACCESS_KEY
DEVICE_SECRET_KEY=$DEVICE_SECRET_KEY
GAUS_URL=$GAUS_URL
CLIENT_VERSION="0.0.1"
EOF


