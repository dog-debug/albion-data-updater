# Find latest Albion Online installer build
# Usage: .\find-latest-build.ps1

$baseUrl = "https://live.albiononline.com/clients"
$found = $false
$now = Get-Date
$tested = 0

Write-Host "Searching for latest Albion Online installer..." -ForegroundColor Cyan
Write-Host ""

# Check last 30 days
for ($d = 0; $d -le 30 -and -not $found; $d++) {
    $date = $now.AddDays(-$d)
    
    # Check every 6 hours
    for ($h = 0; $h -lt 24 -and -not $found; $h += 6) {
        $testDate = $date.AddHours($h)
        $timestamp = $testDate.ToString("yyyyMMddHHmmss")
        $url = "$baseUrl/$timestamp/albion-online-setup.exe"
        
        $tested++
        
        try {
            $resp = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10 -ErrorAction Stop
            if ($resp.StatusCode -eq 200) {
                Write-Host "FOUND: $timestamp" -ForegroundColor Green
                Write-Host "URL: $url"
                Write-Host ""
                Write-Host "Update the workflow with this timestamp:" -ForegroundColor Cyan
                Write-Host "  `$baseUrl/$timestamp/albion-online-setup.exe" -ForegroundColor Yellow
                $found = $true
            }
        }
        catch {
            # Try next
        }
        
        if ($tested % 20 -eq 0) {
            Write-Host "Tested $tested URLs..." -ForegroundColor Gray
        }
    }
}

if (-not $found) {
    Write-Host "No available builds found in last 30 days." -ForegroundColor Red
    Write-Host "Tested $tested URLs."
}
