# Report API

The report api is used for adding data in form of events or metrics from the device to GAUS.

**Prerequisites:** The device has done an [authentication](../docs/authentication.md) and retrieved Token, productGUID and
deviceGUID

This Post object includes on version, header and a list of data where data can be of different types.
```javascript
 Authorization: Bearer ${token}
 POST: /device/${productGUID}/${deviceGUID}/report?[&query-parameter-name=query-parameter-value]* - POST //Note: query parameters are optional,
                                                                                                  //if missing the backend should retrieve the
                                                                                                  // last of known state to decorate the data segment.
{
  "version": "1.0.0",                  // Mandatory
  "header": {                          // Mandatory
    "seqNo": 123,                      // Optional, logical sequence of the order reports has been created
    "ts": "2014-08-16T02:08:00.000Z",  // Mandatory, the timestamp when the report was sent from client
    "tags": {                          // Optional, these tags will be joined into the data tags.
       "hostname": "sdf12345",
       "myTag2": "clientTag123",
        ...
    }
 }, 
  "data": [
    { // See the "data" section for more information:
      "type": "...",  // Mandatory, here exist both defined typed and user typed, see link for more information
      "ts": "...",    // Mandatory, time stamp when the data was collected
      "v_strings": {"stringkey", "stringvalue", ...}, //Optional, if collecting strings
      "v_floats": {"floatkey", 1.1, ...},             //Optional, if collecting floats
      "v_ints": {"intkey", 1, ...},                   //Optional, if collecting ints
      "tags": {"key": "value", ...}                   //Optional, Tags
    }, ...
  ]
}
 
RESPONSE: 200 OK
Content-Type: application/json
{}
``` 
You as device owner can create your own data type without defining it in the GAUS admin UI before, there are also some predefined types.

The main structure is that all types that start with event.* will be handled as "events" and all data types that started with
metric.* will be handled as metrics.
List of reserved data types:

##### event.update.Status

This event should be sent during a client update. UpdateId is used to get the information about the source and target
 versions and type. 
 ```javascript
{
  "type": "event.update.Status",
  "ts": "2014-08-16T02:07:02.000Z",
  "v_strings": {
     "phase": "download", // [download, verify, install]
     "status": "failed",  // [success, failed]
     "statusCode": "DM000765",
     "logLine": "Disk space problem!",
     "updateId": "0885af56-a81c-4f73-8684-95f5fa609d8e"
   },
   "tags": {"androidSdk": "23"}
}
```
Where: 
* v_strings.phase - [download, verify, install]
* v_strings.status -   [success, failed]
* v_strings.updateId -  (The updateId is part of the update manifest from [check-for-update](../docs/check-for-update.md)
* v_strings.statusCode (Optional) - internal status code in the device
* v_strings.logLine (Optional) - Error message

##### event.generic.*

Generic event, in this example a log.
```javascript
{
  "type": "event.generic.DeviceLog",
  "ts": "2014-08-16T02:05:47.000Z",
  "v_strings": {
     "msg": "Disk is 95% full"
  },
  "tags": {"filename": "syslog"}
}
```
Where:
* v_ints.* - if you would log ints
* v_strings.* - if you would log strings
* v_floats.*  - if you would log floats

##### metric.gauge.*
A gauge is a metric that represents a single numerical value that can arbitrarily go up and down.

Gauges are typically used for measured values like temperatures or current memory usage, but also "counts" that
 can go up and down, like the number of running processes.
 
```javascript
{ 
  "type": "metric.gauge.Cpu",
  "ts": "2014-08-16T02:00:40.000Z", // Timestamp
  "v_floats": {
    "usage_system": 1.3157894738605669,
    "usage_user": 1.3157894743392482
  },
  "tags": {"host": "server01", "core": "0"}

}
```
where:
* v_ints.* - for ints
* v_floats.* - for floats

##### metric.counter.*
A counter is a cumulative metric that represents a single monotonically increasing counter whose value can only
 increase or be reset to zero on restart. For example, you can use a counter to represent the number of requests served, tasks completed, or errors.

Do not use a counter to expose a value that can decrease. For example, do not use a counter for the number
 of currently running processes; instead use a gauge.
 
```javascript
{
  "type": "metric.counter.Bread",
  "ts": "2014-08-16T02:00:39.000Z", // Timestamp (at collection)
  "v_ints": {
    "success": 740020224,
    "errors": 16750706688
  },
  "v_floats": {
    "rainfallInmm": 67.98994896232524
  },
  "tags": {"hostname": "myhost888", ...}
```
where:
* v_ints.* - for ints
* v_floats.* - for floats
