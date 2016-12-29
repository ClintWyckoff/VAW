<#

The following script is to be used as an example to prove that it is both possible as well as easy to completely automate the deployment
of the Veeam Agent for Windows.

To Setup This Sample:
1.) Download the most recent bits of Veeam Agent for Windows from Veeam.com
2.) Manually install and then export out the configuration of your backup
    a.) This is done via the Veeam.Agent.Configurator.exe -export command that's run from "c:\program files\veeam\endpoint backup\"
3.) Place your installation in a central location - below I created a Network Share that is accessible to everyone
4.) Create a source directory c:\vaw and put your license file as well as the Config.xml file that was exported.
    a.) The default location for export is "C:\ProgramData\Veeam\Endpoint\!Configuration\Config.xml"
    b.) Don't forget to show hidden files :) 
5.) The u: Backup is my Tenant Account for my CC Repository and the :p is the password required.

#>

Write-Host -ForegroundColor Green "Step #1: Silently Installing Veeam Agent for Windows"
Write-Host -ForegroundColor Yellow "** Waiting just a minute for the install, please have some patience would ya! **"

#Share location for the Veeam Agent for Windows Executable 
Start-Process -FilePath "\\vac\VeeamAgentWindows\582Build\VeeamAgentWindows_2.0.0.582.exe" -verb runas -ArgumentList "/silent /accepteula"

Start-Sleep -Seconds 120

Stop-Process -Name "Veeam.EndPoint.Tray"

Write-Host -ForegroundColor Green "Step #2: Applying your License File to the Protected Host"

cd "C:\Program Files\Veeam\Endpoint Backup"
Start-Process Veeam.Agent.Configurator.exe -ArgumentList "-license /f:C:\VAW\veeam_agent_windows_trial_10.lic"

Write-Host -ForegroundColor Green "Step #3: Applying your Desired Configuration to the Protected Host"

Start-Process Veeam.Agent.Configurator.exe -ArgumentList '-import /f:C:\VAW\Config.xml /u: "backup" /p:"Veeam123!"'

Start-Process 'C:\Program Files\Veeam\Endpoint Backup\Veeam.EndPoint.Tray.exe'