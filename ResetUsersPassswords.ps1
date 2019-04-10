<#
	.SYNOPSIS
		To reset AD password for list of users

	.DESCRIPTION
		To reset AD user password and force to change at next logon.
		This script is built based on the request in TechNet Gallery.

	.PARAMETER  UserID
		SAMACCOUNTNAME of the User ID

	.PARAMETER  ParameterB
		Default Password or some string

	.EXAMPLE 1
		PS C:\> .\ResetUsersPasswords.ps1 

	.INPUTS
		System.String,System.String
		
	.NOTES
		Please test before comitting changes in environment.


#>
#import relevant modules
import-module activeDirectory

#This function resets the password and sets the change password at logon parameter.
Function Reset-ADUserPassword
{
	param
	(
		[Parameter(ValueFromPipeline=$true)]
		[String]$userID,
		[String]$password
	)
	$ADuser =  Get-ADUser $userID
	If($ADuser)
	{
		Set-adaccountpassword $userID -reset -newpassword (ConvertTo-SecureString -AsPlainText $password -Force)
		Set-aduser $userID -changepasswordatlogon $true
	}
}

#get list of users, we will need to enter the password.
$users = get-content .\users.txt 
$passwordCandidate = "Iwuoma9amIwuoma9am"

#for loop will go through each user and reset their password

if($passwordCandidate){
	foreach ($u in $users) {
		write-host "Changing password for $u"
    		try {
   		 Reset-ADUserPassword -userID $u -password $passwordCandidate
		 write-host "User $u's password has been changed!" -ForegroundColor Green
   		}
    		catch {
       		 Write-Error -Message "User $u does not exist"
    		}
	}
}

else {
	write-host "password is not entered!" -BackgroundColor Black -ForegroundColor Red
}
