#!/usr/bin/env zsh

function plist-print() {
	[[ -e ${1} ]] && /usr/libexec/PlistBuddy -c 'Print' ${1}
}

function print-non-directories() {
	ls -1ap $@ | sift --invert-match '/'
}
plist-print ~/Library/Preferences/com.apple.dt.Xcode.plist | sift 'Simulator'

print-non-directories ~/Library/Developer/CoreSimulator/Devices
plist-print ~/Library/Developer/CoreSimulator/Devices/device_set.plist
plist-print ~/Library/Developer/CoreSimulator/Devices/.default_created.plist

() {
	[[ -d ${1} ]] && open -a ${1}
} "$(xcode-select -p)/Applications/Simulator.app" && sleep 5
print-non-directories ~/Library/Developer/CoreSimulator/Devices
plist-print ~/Library/Developer/CoreSimulator/Devices/device_set.plist
plist-print ~/Library/Developer/CoreSimulator/Devices/.default_created.plist
