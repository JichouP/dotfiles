Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.0.11692/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile winget.appxbundle -UseBasicParsing
Add-AppxPackage -Path winget.appxbundle
rm winget.appxbundle