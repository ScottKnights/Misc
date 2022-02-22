# Add a Central profile to the All users/All hosts profile on machine startup
# Deploy by GPO or other management system

# Create a script containing the functions you want to deploy to all machines. Rename to .PSM1 to convert to module. 
# Specify path to module
$centprofile="\\SERVER\SHARE\centprofile.psm1"

# Create the "All users/All hosts" profile on the machine if it doesn't already exist
$centprof=$profile.AllUsersAllHosts
if (-not (test-path $centprof)) {
	New-Item -path (split-path $centprof -parent) -Name (split-path $centprof -leaf) -ItemType File
}

# Wait to make sure the file exists
while (-not (test-path $centprof)) {
	start-sleep 1
}

# String to add the central profile to the machine all users/all hosts profile if it isn't already there
$cpstring='$cp="'+$centprofile+'";if (test-path $cp) {import-module $cp}'

# Test if the string has already been added to the profile. If not, add it. 
$content = get-content $centprof
if (-not($content | select-string -pattern $cpstring -simplematch)) {
	$cpstring|Add-Content -Path $centprof
}
