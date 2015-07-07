$file = "C:\users\devadmin\Desktop\starwars.csv"

##Make objects out of the Data
function WW5-add-user ($file) {

##Import the file
$import = Import-Csv  $file

ForEach ($item in $import)
{ 
  $roleID = $($item.Role)
  $Fullname = $($item.Fullname)
  $email = $($item.Email)
  $Username = $($item.Username)
  $Password = $($item.Password)


$newuser = @"
{
"roleId":"$roleID",
"fullName":"$fullname",
"email":"$email",
"userName":"$username",
"password":"$password"
}
"@


$token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJJc3N1ZXIiOiJodHRwOi8vd3d3LmJ1c2luZXNzc3lzdGVtc3VrLmNvbS93b3Jkd2F0Y2giLCJBdWRpZW5jZSI6Imh0dHA6Ly93d3cuYnVzaW5lc3NzeXN0ZW1zdWsuY29tL3dvcmR3YXRjaC9wb3J0YWwiLCJFeHBpcnkiOiJcL0RhdGUoMjUzNDAyMzAwNzk5OTk5KVwvIiwiTmFtZSI6IlRvYnkiLCJQZXJtaXNzaW9ucyI6WyJVc2VyQWRtaW4iLCJEZXZpY2VBZG1pbiIsIlJvbGVBZG1pbiJdfQ.ftyGEDp0y5pK7z3iQ9twkwZko7kX958rJIJmGwbd_Yw"

invoke-webrequest -Method POST  -uri "http://10.10.10.109/api/users" -Body $newuser -Headers @{Authorization = $token; Accept = 'application/json'} -ContentType application/json
}

}