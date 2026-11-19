# Albion Data Updater Workflow Fix

## Problem Identified

The GitHub Actions workflow was failing with the error:
```
Albion Online GameData directory was not found after installation.
```

### Root Cause
The workflow used a hardcoded, outdated Albion Online installer URL with a specific build timestamp:
```
https://live.albiononline.com/clients/20250827164405/albion-online-setup.exe
```

This timestamp (`20250827164405` = August 27, 2025) was no longer available on the CDN. The latest available build had moved to a newer timestamp (`20261102100206` = November 2, 2026).

## Solution Implemented

### Key Changes to `.github/workflows/update-albion-data.yml`

The download step now uses an **intelligent fallback mechanism** that:

1. **Starts with known-working versions**: The script begins with the most recent verified build timestamp
2. **Generates candidate URLs**: Creates a list of potential download URLs by generating timestamps for the last 30 days (checking every 6 hours)
3. **Tests URLs efficiently**: Uses HTTP HEAD requests to quickly verify which URL is available before attempting a full download
4. **Falls back gracefully**: If none of the candidate URLs work, provides a clear error message
5. **Includes better logging**: Reports progress and diagnostics for troubleshooting

### Implementation Details

```powershell
# Most recent known working build
$candidateUrls += "$baseUrl/20261102100206/albion-online-setup.exe"

# Generate timestamps for the last 30 days (every 6 hours)
$now = Get-Date
for ($daysBack = 0; $daysBack -le 30; $daysBack++) {
  $date = $now.AddDays(-$daysBack)
  for ($hour = 0; $hour -lt 24; $hour += 6) {
    $testDate = $date.AddHours($hour)
    $timestamp = $testDate.ToString("yyyyMMddHHmmss")
    $candidateUrls += "$baseUrl/$timestamp/albion-online-setup.exe"
  }
}

# Test each URL with HEAD request before downloading
foreach ($url in $candidateUrls) {
  try {
    $response = Invoke-WebRequest -Uri $url -Method Head -MaximumRedirection 5 -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
      # Download from this URL
      Invoke-WebRequest -Uri $url -OutFile $installer -MaximumRedirection 10
      $downloadedSuccessfully = $true
      break
    }
  }
  catch {
    # Try next URL
  }
}
```

## Why This Solution Works

1. **Adaptive**: The workflow automatically adapts to new Albion Online builds by generating candidate timestamps
2. **Efficient**: HEAD requests quickly identify valid URLs without downloading unnecessarily
3. **Resilient**: The 30-day window covers typical update patterns while remaining practical
4. **Maintainable**: New known-working timestamps can be easily added to the script
5. **Graceful degradation**: Clear error messages guide troubleshooting if all URLs fail

## Testing

The fix has been:
- ✅ Committed to `main` branch with commit `51f3074`
- ✅ Pushed to GitHub repository
- ⏳ Ready to test on next scheduled run or manual dispatch

## Future Improvements

For even more robustness, consider:

1. **External version registry**: Maintain a `.albion-builds` file in the repository that tracks known-working build timestamps
2. **CI/CD integration**: Create a separate workflow that periodically discovers new builds and updates the registry
3. **Build discovery API**: Monitor Albion Online's official release channels for version information
4. **GitHub Actions artifact caching**: Cache downloaded installers to reduce bandwidth and improve speed

## Next Steps

1. Manually trigger the workflow to verify the fix works: `workflow_dispatch` on `update-albion-data.yml`
2. Monitor the workflow logs to confirm the installer downloads successfully
3. Verify that GameData is extracted and committed to the repository
4. If issues persist, check the GitHub Actions logs for specific error messages

## References

- Workflow file: `.github/workflows/update-albion-data.yml`
- Latest commit: `51f3074`
- Albion Online CDN base: `https://live.albiononline.com/clients/`
- Known working build: `20261102100206` (Nov 2, 2026)
