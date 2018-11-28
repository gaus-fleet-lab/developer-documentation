#!/bin/bash
#
# A script that can read the register.sh output and check for update
#

# sendReport verions, sequence, phased[download, verify, installation], status[succses, failed], statusCode, updateId, update-version
function sendReport {
  # ISO8601 UTC timestamp + ms:wq
  TIMESTAMP_UTC=`date --utc +%FT%T.%3NZ`

  # You can use any number of v_ints, v_floats and v_strings in the same data entity and combine them
  cat > report.json <<EOF
{
    "version": "1.0.0",
    "header": {
        "ts": "$TIMESTAMP_UTC",
        "tags": { "update-client": "curl" }
    },
    "data": [
        {
          "type": "event.update.Status",
          "ts": "$TIMESTAMP_UTC",
          "v_strings": {
            "phase": "$3",
            "status": "$4",
            "statusCode": "$5",
            "updateId": "$6",
            "updateType": "fw",
            "sourceSoftwareVersion": "$1",
            "targetSoftwareVersion": "$7"
          },
          "tags": { "host": "$HOSTNAME"}
        }
    ]
}
EOF

  # Post report
  REPORT_CURL="curl -X POST \
                    -H \"Authorization: Bearer $TOKEN\" \
                    -H \"Content-Type: application/json\" \
                    -d @report.json \"$GAUS_URL/device/$8/$9/report\"  | jq ."
  echo $REPORT_CURL
  eval $REPORT_CURL
  rm report.json
}

# Read in the device.data file
if [ -f "$1" ]; then
  source $1
else
  echo "Usage: ./device-check-for-update.sh device.data \n"
  echo " (Run register.sh to create the device.data) \n"
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

echo token=$TOKEN
echo productGUID=$PRODUCT_GUID deviceGUID=$DEVICE_GUID
if [ -z "$TOKEN" ] || [ -z "$PRODUCT_GUID" ] || [ -z "$DEVICE_GUID" ]; then
  echo "Failed to authenticate"
  exit 1
fi
# Check for update
CHECK_FOR_UPDATE_CURL="curl -X GET \
                            -H \"Authorization: Bearer $TOKEN\" \
                            -H \"Content-Type: application/json\" \
                            \"$GAUS_URL/device/$PRODUCT_GUID/$DEVICE_GUID/check-for-updates?firmware-version=$CLIENT_VERSION\""
echo $CHECK_FOR_UPDATE_CURL
UPDATE_MANIFEST=$(eval $CHECK_FOR_UPDATE_CURL)
UPDATE_ID=$(echo $UPDATE_MANIFEST | jq --raw-output .updates[0].updateId)
UPDATE_URL=$(echo $UPDATE_MANIFEST | jq --raw-output .updates[0].downloadUrl)
UPDATE_VERSION=$(echo $UPDATE_MANIFEST | jq --raw-output .updates[0].version)
if [ -z "$UPDATE_ID" ] || [ "$UPDATE_ID" == "null" ]; then
  echo "No update"
  echo $UPDATE_MANIFEST | jq .
  exit 0
fi
# Got a update
SEQ=0
echo $UPDATE_MANIFEST | jq .updates[0]
sendReport $CLIENT_VERSION $SEQ  "download" "success" "0" $UPDATE_ID $UPDATE_VERSION $PRODUCT_GUID $DEVICE_GUID
((++SEQ))
sendReport $CLIENT_VERSION $SEQ  "verify" "success" "0" $UPDATE_ID $UPDATE_VERSION $PRODUCT_GUID $DEVICE_GUID
((++SEQ))
sendReport $CLIENT_VERSION $SEQ  "installation" "success" "0" $UPDATE_ID $UPDATE_VERSION $PRODUCT_GUID $DEVICE_GUID
