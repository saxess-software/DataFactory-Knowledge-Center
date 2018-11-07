
### Steps to configure a powerloading job

1. During Installation of WebApp set a user with full rights as powerloading user  

2. Generate a powershell script according to the example in the folder 'Powerloading example'

3. Configure a Microsoft Job

![Pic](Images/a_Aufgabe.PNG)

![Pic](Images/b_Name.PNG)

![Pic](Images/c_Trigger.PNG)

![Pic](Images/d_Zeitplan.PNG)

![Pic](Images/e_Aktion.PNG)

![Pic](Images/f_Pfade.PNG)

path to the powershell.exe (z.B.: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe)

path of the powershellscript file (z.B.: -file "C:\GitHub\AD01513_BFW_DataFactory\Projekt Unternehmensplanung\1c. Prozess 2018\Powerloading.ps1") !Format einhalten

folder where the powershell script is located (z.B.: C:\GitHub\AD01513_BFW_DataFactory\Projekt Unternehmensplanung\1c. Prozess 2018)

![Pic](images/g_Timeout.PNG)


