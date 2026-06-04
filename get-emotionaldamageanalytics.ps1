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
    # declaring variables
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
    
    # data gathering
    foreach ($Stats in $Status) {

      if ($stats -eq 'hired') {
        Write-Host "Boom! Hired! No emotional damage here!" -ForegroundColor Green
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

    # get the days since the first application
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
      if ($uncertaincount -gt $DeniedCount + $ResponseCount) {
        write-warning "high uncertainty detected: $([math]::round(($UncertainCount / $total * 100), 2))%%"
      }
      elseif ($DeniedCount -gt $ResponseCount) {
        write-warning "high denial rate detected: $([math]::round(($DeniedCount / ($DeniedCount + $ResponseCount) * 100), 2))%"
      }
      elseif ($ResponseCount -gt $DeniedCount) {
        write-host "Application status looks good: $([math]::round(($ResponseCount / ($DeniedCount + $ResponseCount) * 100), 2))% responded" -ForegroundColor Green
      }
    }

    if ($total -gt 0) {
      Write-Host "Uncertain outcomes: $([math]::round(($UncertainCount / $total * 100), 2))%" -ForegroundColor Yellow
    }

  } # END

} # function
