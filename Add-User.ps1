
function Add-User () {
    <#
    .DESCRIPTION
        Imports a CSV File with the following Headers RoleID,FullName,Email,Username and Password.
        Creates the users by making an API call to the WW5 Server.

    .PARAMETER File
        The -File Parameter should be the full path of your CV file.

    .PARAMETER Server
        The -Server Parameter is the address of your WW5 , IP address is preferred, but DNS should work if resolvable.
    
    .PARAMETER token
        The -token Parameter is how Request to the server are authenicated.

    .EXAMPLE
        Add-User -file "C:\users\devadmin\Desktop\starwars.csv" -server 10.10.10.109 -token "eyJ0eXAiOiJKV1QiLCJhbGcaW9wb3J0YWwiLCJF58rJIJmGwbd_Yw"
    #>



    
    [CmdletBinding()] param(
    [parameter(Mandatory=$true)]
    [string]$file ,
    [string]$server,
    [string]$token
    )

Start-Transcript -literalpath c:\test\failedusers.txt -force -append
$DebugPreference = "Continue"
##Import the CSV file
$import = Import-Csv $file
##Make objects out of the Data
ForEach ($item in $import)
{ 
  $roleID = $($item.RoleID)
  $Fullname = $($item.Fullname)
  $email = $($item.Email)
  $Username = $($item.Username)
  $Password = $($item.Password)

##Create JSON form
$newuser = @"
{
"roleID":"$roleID",
"fullName":"$fullname",
"email":"$email",
"userName":"$username",
"password":"$password"
}
"@


try {
       invoke-webrequest -Method POST -uri "http://$server/api/users" -Body $newuser -Headers @{Authorization = $token; Accept = 'application/json'} -ContentType application/json
       }
catch {
        $result = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($result)
        $responseBody = $reader.ReadToEnd();


        If ({$result.StatusCode -eq 400 -or $result.status -eq 500})
        { write-debug  ("Failed to add User" + $newuser + $responseBody )}
        Else {Out-file C:\Added-Users.txt -inputobject $newuser -append }      
}
}
}

