# Update client Curl for GAUS

## 1a) First time setup
* Go to https://<your-subdomain>.sonymobile.com/admin and login with user and password that you have received in your mail inbox
* Click on product and create new product, name it and optionally add some query-parameters
* Extract the product secret and product access to a file called 'bootstrap.conf', e.g.:

 cat <<EOT >> bootstrap.conf
 GAUS_URL=https://ZZZ.sonymobile.com
 PRODUCT_ACCESS_KEY=XXX
 PRODUCT_SECRET_KEY=YYY
 EOT

## 1b) Run register.sh
* This script will "register" the device with the GAUS backend
* It will also create a file named 'device.data' that will be used for the other scripts to access the GAUS. e.g.:
 `./register.sh bootstrap.conf`

# 2) Now you can run device-check-for-update.sh and device-report.sh
* By pointing out the device.data file to the scripts (check-for-update.sh|report.sh) will have access to the backend
 `./check-for-update.sh device.data`
or
 `./report.sh device.data`
