#Registry n Filesystem Artifact Modifier

#Identify MAC Addr
$nics = @(Get-WmiObject -Query "select * from win32_networkadapter where adaptertype != 'Tunnel' and adaptertype is not null" | `
where { $_.description -notmatch 'VMware|Virtual|WAN Miniport|ISATAP|RAS Async|Teredo|Windows Mobile Remote|6to4|Bluetooth' } )

$index = $nics[0].index
$index = $index.tostring().padleft(4,"0")
Write-Output "MAC bisa dimodifikasi pada index: $index"

#Modify MAC Address
Write-Output "<!!!> Memulai modifikasi MAC Address <!!!>"
$regpath = "hklm:\system\CurrentControlSet\control\class\{4D36E972-E325-11CE-BFC1-08002BE10318}\$index"
set-itemproperty -path $regpath -name "NetworkAddress" -value "AABBCCDDEEFF"
Write-Output "<V> Modifikasi MAC Address berhasil dilakukan!"
Write-Output "----------------------------------------"

#Registry
Write-Output "<!!!> Memulai modifikasi registry <!!!>"


$arrayReg = @(
    "HKLM:\HARDWARE\ACPI\DSDT\VBOX__",
    "HKLM:\HARDWARE\ACPI\FADT\VBOX__",
    "HKLM:\HARDWARE\ACPI\RSDT\VBOX__",
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Oracle VM VirtualBox Guest Additions"
    "HKLM:\SOFTWARE\Oracle\VirtualBox Guest Additions",
    "HKLM:\SYSTEM\ControlSet001\Services\VBoxGuest",
    "HKLM:\SYSTEM\ControlSet001\Services\VBoxMouse",
    "HKLM:\SYSTEM\ControlSet001\Services\VBoxService",
    "HKLM:\SYSTEM\ControlSet001\Services\VBoxSF",
    "HKLM:\SYSTEM\ControlSet001\Services\VBoxVideo",
    "HKLM:\SYSTEM\CurrentControlSet\Services\Disk\Enum",
    "HKLM:\SYSTEM\CurrentControlSet\Enum\IDE",
    "HKLM:\SYSTEM\CurrentControlSet\Enum\SCSI"    
)

$arrayRegValBIOS = @(
    "BIOSVersion",
    "BIOSReleaseDate",
    "BIOSProductName",
    "SystemProductName"
)

$arrayRegValSys =@(
    "SystemBiosDate",
    "VideoBiosVersion",
    "SystemBiosVersion"
)


function Get-RandomString {

    $charSet = "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()
    
    for ($i = 0; $i -lt 10; $i++ ) {
        $randomString += $charSet | Get-Random
    }

    return $randomString
}

foreach ($element in $arrayReg){
    if (Get-Item -Path $element -ErrorAction SilentlyContinue) {
        Write-Output "<-> Modifikasi Reg Key $element" 
        Rename-Item -Path $element -NewName $(Get-RandomString)
    
    } Else {
    
        Write-Output '<!> Reg Key ' + $element + ' tidak ada, registry diskip..'
    }
}

foreach ($element in $arrayRegValBIOS){
    if (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SystemInformation" -Name $element -ErrorAction SilentlyContinue) {
        Write-Output "<-> Modifikasi Reg Val $element" 
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SystemInformation" -Name $element -Value $(Get-RandomString)
    } Else {
    
        Write-Output '<!> Reg Val ' + $element + ' tidak ada, registry diskip..'
    }
}

foreach ($element in $arrayRegValSys){
    if (Get-ItemProperty -Path "HKLM:\HARDWARE\Description\System" -Name $element -ErrorAction SilentlyContinue) {
        Write-Output "<-> Modifikasi Reg Val $element" 
        Set-ItemProperty -Path "HKLM:\HARDWARE\Description\System" -Name $element -Value $(Get-RandomString)
    } Else {
    
        Write-Output '<!> Reg Val ' + $element + ' tidak ada, registry diskip..'
    }
}

Write-Output "<!!!> Modifikasi registry selesai! <!!!>"
Write-Output "----------------------------------------"

#Filesystem
Write-Output "<!!!> Memulai modifikasi filesystem <!!!>"
$arrayFileDrivers = @(
    "C:\Windows\system32\drivers\VBoxMouse.sys",
    "C:\Windows\system32\drivers\VBoxGuest.sys",
    "C:\Windows\system32\drivers\VBoxSF.sys",
    "C:\Windows\system32\drivers\VBoxVideo.sys",
    "C:\Windows\system32\drivers\vmmouse.sys",
    "C:\Windows\system32\drivers\vmhgfs.sys",
    "C:\Windows\system32\drivers\vm3dmp.sys",
    "C:\Windows\system32\drivers\vmci.sys",
    "C:\Windows\system32\drivers\vmhgfs.sys",
    "C:\Windows\system32\drivers\vmmemctl.sys",
    "C:\Windows\system32\drivers\vmmouse.sys",
    "C:\Windows\system32\drivers\vmrawdsk.sys",
    "C:\Windows\system32\drivers\vmusbmouse.sys"
)

$arrayFileSys32exe = @(
    "C:\Windows\system32\vboxservice.exe",
    "C:\Windows\system32\vboxtray.exe",
    "C:\Windows\system32\VBoxControl.exe"
)

$arrayFileSys32dll = @(
    "C:\Windows\system32\vboxdisp.dll",
    "C:\Windows\system32\vboxhook.dll",
    "C:\Windows\system32\vboxmrxnp.dll",
    "C:\Windows\system32\vboxogl.dll",
    "C:\Windows\system32\vboxoglarrayspu.dll",
    "C:\Windows\system32\vboxoglcrutil.dll",
    "C:\Windows\system32\vboxoglerrorspu.dll",
    "C:\Windows\system32\vboxoglfeedbackspu.dll",
    "C:\Windows\system32\vboxoglpackspu.dll",
    "C:\Windows\system32\vboxoglpassthroughspu.dll"
)

foreach ($element in $arrayFileSys32dll){
    if (Get-Item -Path $element -ErrorAction SilentlyContinue) {
        Write-Output "<-> Modifikasi dll - $element" 
        Rename-Item "$element" "C:\Windows\system32\$(Get-RandomString).dll"
    
    } Else {
    
        Write-Output 'Error, skipping this file!'
    }
}

foreach ($element in $arrayFileSys32exe){
    if (Get-Item -Path $element -ErrorAction SilentlyContinue) {
        Write-Output "<-> Modifikasi exe - $element"
        Rename-Item "$element" "C:\Windows\system32\$(Get-RandomString).exe"
    
    } Else {
    
        Write-Output 'Error, skipping this file!'
    }
}

foreach ($element in $arrayFileDrivers){
    if (Get-Item -Path $element -ErrorAction SilentlyContinue) {
        Write-Output "<-> Modifikasi sys - $element " 
        Rename-Item "$element" "C:\Windows\system32\drivers\$(Get-RandomString).sys"
    
    } Else {
    
        Write-Output 'Error, skipping this file!'
    }
}

if (Get-Item -Path "C:\\program files\\oracle\\virtualbox guest additions" -ErrorAction SilentlyContinue) {
    Write-Output "<-> Renaming dir C:\\program files\\oracle\\virtualbox guest additions"
    Rename-Item "C:\\program files\\oracle\\virtualbox guest additions" "C:\\program files\\oracle\\$(Get-RandomString)"
}

Write-Output "<!!!> Modifikasi Filesystem selesai! <!!!>"
Write-Output "----------------------------------------"


Write-Output "<!!!> Memulai modifikasi proses <!!!>"
#Processes
$arrayProcesses = $(
    "VBoxService",
    "VBoxTray"
)

foreach ($element in $arrayProcesses){
    if (Get-Process $element -ErrorAction SilentlyContinue) {
        Write-Output "<-> Stopping exe" + $element
        Stop-Process -Name "$element"
    
    } Else {
    
        Write-Output 'Error, skipping this file!'
    }
}

Write-Output "<!!!> Modifikasi proses berhasil <!!!>"
Write-Output "----------------------------------------"
Write-Output "<!!!> Memulai modifikasi WMI Object <!!!>"
Write-Output "<-> Removing Win32_PnPEntity"
Remove-WmiObject Win32_PnPEntity
Write-Output "<!!!> Modifikasi WMI Object berhasil <!!!>"
Write-Output "----------------------------------------"
Write-Output "<-->Program selesai dijalankan<-->"
Read-Host -Prompt "Press Enter to exit"