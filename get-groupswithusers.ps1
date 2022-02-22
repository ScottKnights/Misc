# Return a list of all groups in a searchbase that contain user objects
function get-groupswithusers {
	Param(
		[Parameter(Position=0)]
		[String] $searchbase
	)
	if (-not $searchbase) {
		$searchbase="dc="+$env:userdnsdomain.replace(".",",dc=")
	}
	$ugroups=@()
	$groups=get-adgroup -filter * -searchbase $searchbase
	foreach ($group in $groups) {
		$users=get-adgroupmember $group|where-object {$_.objectClass -eq "user"}
		if ($count=$users.count -gt 0) {
			$ugroups += $group
		}
	}
	return $ugroups
}
