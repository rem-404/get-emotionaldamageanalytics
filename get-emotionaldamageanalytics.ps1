
<#
Emotional devastator v-1.0

Import-csv .\CsvOfDissapointment.csv

CSV Format
Date	Company	Position	Platform	Status	Notes	Odds	UserName	Password	Link

#>

function Get-EmotionalDamageAnalytics {

  [cmdletbinding()]
  param (
    [parameter(ValueFromPipelineByPropertyName = $true)]
    [string[]]$Date,
    [parameter(ValueFromPipelineByPropertyName = $true)]
    [string[]]$Status
  )

  BEGIN {
    $FirstDate = $null
    $HiredCount = 0
    $DeniedCount = 0
    $ResponseCount = 0
    $UncertainCount = 0
  }

  PROCESS {
    if ($null -eq $FirstDate -and $Date) {
      $FirstDate = $Date[0] 
    }
    
    foreach ($Stats in $Status) {

      if ($stats -eq 'hired') {
        Write-Host "Boom! Hired! No emonotional damage here!" -ForegroundColor Green
        $HiredCount += 1
      }
      elseif ($Stats -eq 'denied') {
        $DeniedCount += 1
      }
      elseif ($Stats -eq 'responded') {
        $ResponseCount += 1
      }
      else {
        $UncertainCount += 1
      }
    } # foreach

  } # PROCESS

  END {

    $total = $HiredCount + $DeniedCount + $ResponseCount + $UncertainCount

    $DaysPast = "Unknown"
    if ($FirstDate) {
      $DaysPast = [math]::Round(((Get-Date) - [DateTime]$FirstDate).TotalDays, 0)
    }
    
    [PSCustomObject]@{
      CampaignStartDate = $FirstDate
      DaysSinceStart    = $DaysPast
      TotalApplications = $total
      Hired             = $HiredCount
      Denied            = $DeniedCount
      Responded         = $ResponseCount
      Uncertain         = $UncertainCount
    }

    # Check if the Math is mathing
    $ValidResponses = $DeniedCount + $ResponseCount
    if ($ValidResponses -gt 0) {
      if ($DeniedCount -gt $ResponseCount) {
        write-warning "high denial rate detected: $([math]::round(($DeniedCount / ($DeniedCount + $ResponseCount) * 100), 2))%"
      }
      else {
        write-host "Application status looks good: $([math]::round(($ResponseCount / ($DeniedCount + $ResponseCount) * 100), 2))% responded" -ForegroundColor Green
      }
    }

    if ($total -gt 0) {
      Write-Host "Uncertain outcomes: $([math]::round(($UncertainCount / $total * 100), 2))%" -ForegroundColor Yellow
    }

  } # END

} # function

<#
SAMPLE OUTPUT

PS C:\Logs> import-csv .\CsvOfDisappointment.csv | Get-EmotionalDamageAnalytics

CampaignStartDate : 6/3/2026
DaysSinceStart    : 2
TotalApplications : 7
Hired             : 0
Denied            : 3
Responded         : 2
Uncertain         : 2

WARNING: high denial rate detected: 60%
Uncertain outcomes: 28.57%
PS C:\Logs>
#>
