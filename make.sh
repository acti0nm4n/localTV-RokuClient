#!/bin/bash
cd pkg
zip -r ../localTV.zip .
cd ..
curl --form archive=@localTV.zip --form "mysubmit=Replace" "http://192.168.1.12/plugin_install"