#!/bin/bash

set -eo pipefail

xcodebuild -workspace Me-iOS.xcworkspace \
            -scheme DevelopMe-iOS \
            -destination platform=iOS\ Simulator,OS=13.3,name=iPhone\ 11 
