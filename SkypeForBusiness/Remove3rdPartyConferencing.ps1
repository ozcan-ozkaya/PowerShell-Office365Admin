# Script to bulk remove 3rd party conferencing details for all users
#

# Load the Skype Online Connector module
Import-Module SkypeOnlineConnector

# Establish a session to Exchange Online
$sfbSession = New-CsOnlineSession
Import-PSSession -Session $sfbSession -AllowClobber

# AcpInfo to match (doesn't need to be the full name)
$acpName = 'BT Conferencing UK_EMEA'

# Get all conferencing users matching the above info
$thirdPartyAcps = Get-CsUserAcp | Where-Object {$_.AcpInfo -match $acpName}

# Run through the users and remove their ACP info
foreach ($thirdPartyUser in $thirdPartyAcps) {
    $acpInfoName = ([xml]$thirdPartyUser.AcpInfo).acpInformation.name
    Remove-CsUserAcp -Identity $thirdPartyUser.Identity -Name $acpInfoName -WhatIf
}

# End the PS Session
Remove-PSSession -Session $sfbSession
