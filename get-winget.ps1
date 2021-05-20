Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v-0.3.11201-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle -OutFile winget.appxbundle -UseBasicParsing
Add-AppxPackage -Path winget.appxbundle
rm winget.appxbundle