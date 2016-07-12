$global:DSCModuleName = 'xWebAdministration'
$global:DSCResourceName = 'MSFT_xSSLSettings'

#region HEADER
[String] $moduleRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $Script:MyInvocation.MyCommand.Path))
 if ( (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
      (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'))
}

Import-Module (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $Global:DSCModuleName `
    -DSCResourceName $Global:DSCResourceName `
    -TestType Unit
#endregion

# Begin Testing

try
{
    #region Pester Tests

    InModuleScope $DSCResourceName {

        Describe "$global:DSCResourceName\Test-TargetResource" {
            Context 'Ensure is Present and SSLSettings is Present' {
                Mock Get-TargetResource -Verifiable {return @{
                    Name = 'Test'
                    Bindings = @('SSL')
                    Ensure = 'Present'
                }}

                $result = Test-TargetResource -Name 'Test' -Ensure 'Present' -Bindings 'SSL'

                Assert-VerifiableMocks

                It 'should return true' {
                    $result | should be $true
                }
            }

            Context 'Ensure is Absent and SSLSettings is Absent' {
                Mock Get-TargetResource {return @{
                    Name = 'Test'
                    Bindings = @('SSL')
                    Ensure = 'Absent'
                }}

                $result = Test-TargetResource -Name 'Test' -Ensure 'Absent' -Bindings 'SSL'

                Assert-VerifiableMocks

                It 'should return true' {
                    $result | should be $true
                }
            }

            Context 'Ensure is Present and SSLSettings is Absent' {
                Mock Get-TargetResource {return @{
                    Name = 'Test'
                    Bindings = @('SSL')
                    Ensure = 'Absent'
                }}

                $result = Test-TargetResource -Name 'Test' -Ensure 'Present' -Bindings 'SSL'

                Assert-VerifiableMocks

                It 'should return true' {
                    $result | should be $false
                }
            }
        }

        Describe "$global:DSCResourceName\Get-TargetResource" {
            Context 'Command finds SSL Settings' {
                Mock Assert-Module -Verifiable { }
                Mock Get-WebConfigurationProperty -Verifiable {return 'SSL'}

                $result = Get-TargetResource -Name 'Name' -Bindings 'Test'
                $expected = @{
                    Name = 'Name'
                    Bindings = 'SSL'
                    Ensure = 'Present'
                }

                Assert-VerifiableMocks

                It 'should return the correct bindings' {
                    $result.Bindings | should be $expected.Bindings
                }

                It 'should return the correct ensure' {
                    $result.Ensure | Should Be $expected.Ensure
                }
            }

            Context 'Command does not find SSL Settings' {
                Mock Assert-Module -Verifiable { }
                Mock Get-WebConfigurationProperty -Verifiable {return $false}

                $result = Get-TargetResource -Name 'Name' -Bindings 'Test'
                $expected = @{
                    Name = 'Name'
                    Bindings = 'None'
                    Ensure = 'Absent'
                }

                Assert-VerifiableMocks

                It 'should return the correct bindings' {
                    $result.Bindings | should be $expected.Bindings
                }

                It 'should return the correct ensure' {
                    $result.Ensure | Should Be $expected.Ensure
                }
            }
        }

        Describe "$global:DSCResourceName\Set-TargetResource" {
            Context 'SSL Bindings set to none' {
                Mock Assert-Module -Verifiable { }
                Mock Set-WebConfigurationProperty -Verifiable {}

<<<<<<< HEAD
                $result = (Set-TargetResource -Name 'Name' -Bindings 'None' -Ensure 'Present' -Verbose) 4>&1
                $string = $LocalizedData.SettingSSLConfig -f 'Name', 'None'
                $expected = "Set-TargetResource: $string"
=======
                $result = (Set-TargetResource -Name 'Name' -Bindings '' -Ensure 'Present' -Verbose) 4>&1
                # Check that the LocalizedData message from the Set-TargetResource is correct
                $resultMessage = $LocalizedData.SettingSSLConfig -f 'Name', ''
>>>>>>> upstream/dev

                Assert-VerifiableMocks

                It 'should return the correct string' {
                    $result | Should Be $resultMessage
                }
            }

            Context 'SSL Bindings set to SSL' {
                Mock Assert-Module -Verifiable { }
                Mock Set-WebConfigurationProperty -Verifiable {}

<<<<<<< HEAD
                $result = (Set-TargetResource -Name 'Name' -Bindings 'SSL' -Ensure 'Present' -Verbose) 4>&1
                $string = $LocalizedData.SettingSSLConfig -f 'Name', 'SSL'
                $expected = "Set-TargetResource: $string"
=======
                $result = (Set-TargetResource -Name 'Name' -Bindings 'Ssl' -Ensure 'Present' -Verbose) 4>&1
                # Check that the LocalizedData message from the Set-TargetResource is correct
                $resultMessage = $LocalizedData.SettingSSLConfig -f 'Name', 'Ssl'
>>>>>>> upstream/dev

                Assert-VerifiableMocks

                It 'should return the correct string' {
                    $result | Should Be $resultMessage
                }
            }

            Context 'SSL Bindings set to Ssl,SslNegotiateCert,SslRequireCert' {
                Mock Assert-Module -Verifiable { }
                Mock Set-WebConfigurationProperty -Verifiable {}

                $result = (Set-TargetResource -Name 'Name' -Bindings @('Ssl','SslNegotiateCert','SslRequireCert') -Ensure 'Present' -Verbose) 4>&1
                # Check that the LocalizedData message from the Set-TargetResource is correct
                $resultMessage = $LocalizedData.SettingSSLConfig -f 'Name', 'Ssl,SslNegotiateCert,SslRequireCert'

                Assert-VerifiableMocks

                It 'should return the correct string' {
                    $result | Should Be $resultMessage
                }
            }
        }
    }
}
finally
{
    #region FOOTER
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
    #endregion
}
