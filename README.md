# VBoxArtifactMod
This script is used to modify the string artifacts inside Virtual Machine VBox to hide it from VM detection techniques which is commonly used by malware. The script uses reference from [VBoxCloak](https://github.com/d4rksystem/VBoxCloak). There are some additional string artifacts which is modified by VboxArtifactMod such as MAC address and WMI object. Another artifacts are registry, filesystem, and process. The string artifacts of all these kind of artifacts are 50 in total.

## Warnings Before Use
1. Use only in a VM, not in the host.
2. Make a snapshot of the VM before running this.

## Usage
To use with .ps1:
1. Run it as administrator.
2. Let the modification goes on.
3. Don't forget to go back to previous snapshot when you want to use the VM in normal condition.

To use with the executable file:
1. Download [PsExec](https://docs.microsoft.com/en-us/sysinternals/downloads/psexec) and extract it from PsTools zip file. Locate psexec.exe to `c:\windows\system32`.
2. Open command prompt as administrator.
3. Run VboxArtifactMod executable file using `psexec -s -i <path VboxArtifactMod.exe>`. Choose 'Agree' in the PsExec License Agreement window.
4. Let the modification goes on.
5. Don't forget to go back to previous snapshot when you want to use the VM in normal condition.
