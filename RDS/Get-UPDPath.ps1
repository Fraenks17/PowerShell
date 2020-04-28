<#

This script returns the UPD path that is configured on a server.

Andy Morales
#>
function Test-RegistryValue {
    #Modified version of the function below
    #https://www.jonathanmedd.net/2014/02/testing-for-the-presence-of-a-registry-key-and-value.html
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true,
            Position = 1,
            HelpMessage = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM')]
        [ValidatePattern('Registry::.*')]
        [ValidateNotNullOrEmpty()]
        [String]$Path,

        [parameter(Mandatory = $true,
            Position = 2)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [parameter(Position = 3)]
        [ValidateNotNullOrEmpty()]$ValueData
    )
    try {
        if ($ValueData) {
            if ((Get-ItemProperty -Path $Path -ErrorAction Stop | Select-Object -ExpandProperty $Name -ErrorAction Stop) -eq $ValueData) {
                return $true
            }
            else {
                return $false
            }
        }
        else {
            $RegKeyCheck = Get-ItemProperty -Path $Path -ErrorAction Stop | Select-Object -ExpandProperty $Name -ErrorAction Stop | Out-Null
            if ($null -eq $RegKeyCheck) {
                #if the Key Check returns null then it probably means that the key does not exist.
                return $false
            }
            else {
                return $true
            }
        }
    }
    catch {
        return $false
    }
}

#Check to see if UPDs are enabled
if (Test-RegistryValue -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server\ClusterSettings' -Name UvhdEnabled -ValueData 1) {
    if (Test-RegistryValue -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server\ClusterSettings' -Name UvhdShareUrl) {
        Return (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server\ClusterSettings' -Name UvhdShareUrl).UvhdShareUrl
    }
    else {
        Return ''
    }
}
else {
    Return ''
}