#!/bin/bash -ex

# A script that can read the register.sh output and check for update
# Run register.sh to create device.json
if [ -f "$1" ]; then
  source $1
else
  echo "Usage ./report.sh device.data\n"
  echo " (Run the register.sh to create the device.data file) \n"
  exit 1
fi
# Get token
AUTH_CURL="curl -X POST \
                --data \"{ \\\"deviceAuthParameters\\\": { \\\"accessKey\\\": \\\"$DEVICE_ACCESS_KEY\\\", \\\"secretKey\\\": \\\"$DEVICE_SECRET_KEY\\\" }}\" \
                -H \"Content-Type: application/json\" \
                $GAUS_URL/authenticate"
echo $AUTH_CURL
AUTH_MANIFEST=$(eval $AUTH_CURL)
TOKEN=$(echo $AUTH_MANIFEST | jq --raw-output .token)
DEVICE_GUID=$(echo $AUTH_MANIFEST | jq --raw-output .deviceGUID)
PRODUCT_GUID=$(echo $AUTH_MANIFEST | jq --raw-output .productGUID)

# Create some data
DATA_NUMBER_OF_PROCESSES=`ps aux --no-heading | wc -l`
DATA_CPU_LOAD=`top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'`
TIMESTAMP_UTC=`date --utc +%FT%TZ`

# You can use any number of v_ints, v_floats and v_strings in the same data entity and combine them
cat > report.json <<EOF
{
    "version": "1.0.0",
    "header": {
        "ts": "$TIMESTAMP_UTC"
    },
    "data": [
        {
            "type": "metric.counter.Proc",
            "ts": "$TIMESTAMP_UTC",
            "v_ints": {
                "numberOfProc": $DATA_NUMBER_OF_PROCESSES
            }
        },
        {
            "type": "metric.counter.Cpu",
            "ts": "$TIMESTAMP_UTC",
            "v_floats": {
                "cpuLoad": $DATA_CPU_LOAD
            }
        }
    ]
}
EOF

# Post report
curl -X POST \
     -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
     -d @report.json \
     "$GAUS_URL/device/$PRODUCT_GUID/$DEVICE_GUID/report?firmware-version=$CLIENT_VERSION"  | jq .
