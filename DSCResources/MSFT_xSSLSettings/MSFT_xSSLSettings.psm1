<<<<<<< HEAD
Import-Module $PSScriptRoot\..\Helper.psm1 -Verbose:$false
=======
# Load the Helper Module
Import-Module -Name "$PSScriptRoot\..\Helper.psm1"
>>>>>>> upstream/dev

data LocalizedData
{
    # culture="en-US"
<<<<<<< HEAD
    ConvertFrom-StringData @'
        UnableToFindConfig = Unable to find {0} in AppHost Config
        SettingSSLConfig   = Setting {0} SSL binding to {1}
        SSLBindingsCorrect = SSL Bindings for {0} are correct
        SSLBindingsAbsent  = SSL Bidnings for {0} are Absent
=======
    ConvertFrom-StringData -StringData @'
        UnableToFindConfig       = Unable to find configuration in AppHost Config.
        SettingsslConfig         = Setting {0} ssl binding to {1}.
        sslBindingsCorrect       = ssl Bindings for {0} are correct.
        sslBindingsAbsent        = ssl Bindings for {0} are absent.
        VerboseGetTargetResource = Get-TargetResource has been run.
>>>>>>> upstream/dev
'@
}


function Get-TargetResource
{
    <#
    .SYNOPSIS
        This will return a hashtable of results 
    #>

    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String] $Name,

<<<<<<< HEAD
        [parameter(Mandatory = $true)]
        [string[]] $Bindings
=======
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [ValidateSet('','Ssl','SslNegotiateCert','SslRequireCert','Ssl128')]
        [String[]] $Bindings
>>>>>>> upstream/dev
    )

    Assert-Module

    $Ensure = 'Absent'
    $Bindings = 'None'

    try
    {
        $params = @{
            PSPath   = 'MACHINE/WEBROOT/APPHOST'
            Location = $Name
            Filter   = 'system.webServer/security/access'
            Name     = 'sslFlags'
        }

        $sslSettings = Get-WebConfigurationProperty @params

        # If SSL is configured at all this will be a String else
        # it'll be a configuration object.
        if ($sslSettings.GetType().FullName -eq 'System.String')
        {
            $Bindings = $sslSettings.Split(',')
            $Ensure = 'Present'
        }
    }
    catch [Exception]
    {
        New-TerminatingError -ErrorId 'UnableToFindConfig'`
                             -ErrorMessage $ErrorMessage `
                             -ErrorCategory 'InvalidResult'
    }

    Write-Verbose -Message $LocalizedData.VerboseGetTargetResource

    return @{
        Name = $Name
        Bindings = $Bindings
        Ensure = $Ensure
    }
}

function Set-TargetResource
{
    <#
    .SYNOPSIS
        This will set the desired state
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String] $Name,

<<<<<<< HEAD
        [parameter(Mandatory = $true)]
        [string[]] $Bindings,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present"
=======
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [ValidateSet('','Ssl','SslNegotiateCert','SslRequireCert','Ssl128')]
        [String[]] $Bindings,

        [ValidateSet('Present','Absent')]
        [String] $Ensure = 'Present'
>>>>>>> upstream/dev
    )

    Assert-Module

    if ($Ensure -eq 'Absent' -or $Bindings.toLower().Contains('none'))
    {
        $params = @{
            PSPath   = 'MACHINE/WEBROOT/APPHOST'
            Location = $Name
            Filter   = 'system.webServer/security/access'
            Name     = 'sslFlags'
            Value    = ''
        }

        Write-Verbose -Message ($LocalizedData.SettingsslConfig -f $Name, 'None')
        Set-WebConfigurationProperty @params
    }
    
    else
    {
        $sslBindings = $Bindings -join ','
        $params = @{
            PSPath   = 'MACHINE/WEBROOT/APPHOST'
            Location = $Name
            Filter   = 'system.webServer/security/access'
            Name     = 'sslFlags'
            Value    = $sslBindings
        }

        Write-Verbose -Message ($LocalizedData.SettingsslConfig -f $Name, $params.Value)
        Set-WebConfigurationProperty @params
    }
}

function Test-TargetResource
{
    <#
    .SYNOPSIS
        This tests the desired state. If the state is not correct it will return $false.
        If the state is correct it will return $true
    #>

    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String] $Name,

<<<<<<< HEAD
        [parameter(Mandatory = $true)]
        [string[]] $Bindings,

        [ValidateSet("Present","Absent")]
        [System.String]
        $Ensure = "Present"
=======
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [ValidateSet('','Ssl','SslNegotiateCert','SslRequireCert','Ssl128')]
        [String[]] $Bindings,

        [ValidateSet('Present','Absent')]
        [String] $Ensure = 'Present'
>>>>>>> upstream/dev
    )

    $sslSettings = Get-TargetResource -Name $Name -Bindings $Bindings

    if ($Ensure -eq 'Present' -and $sslSettings.Ensure -eq 'Present')
    {
<<<<<<< HEAD
        $sslComp = Compare-Object -ReferenceObject $Bindings -DifferenceObject $sslSettings.Bindings -PassThru
        if ($sslComp -eq $null)
=======
        $sslComp = Compare-Object -ReferenceObject $Bindings `
                                  -DifferenceObject $sslSettings.Bindings `
                                  -PassThru
        if ($null -eq $sslComp)
>>>>>>> upstream/dev
        {
            Write-Verbose -Message ($LocalizedData.sslBindingsCorrect -f $Name)
            return $true;
        }
    }

    if ($Ensure -eq 'Absent' -and $sslSettings.Ensure -eq 'Absent')
    {
        Write-Verbose -Message ($LocalizedData.sslBindingsAbsent -f $Name)
        return $true;
    }

    return $false;
}

Export-ModuleMember -Function *-TargetResource
