# Testing the Albion Data Updater Workflow Fix

## Quick Status

✅ **Fix Applied**: Commits `51f3074` and `068e891` have been pushed to `main`

## How to Test

### Option 1: Manual Workflow Dispatch (Recommended)
1. Go to GitHub: https://github.com/dog-debug/albion-data-updater
2. Click **Actions** tab
3. Select **Update Albion Online data** workflow on the left
4. Click **Run workflow** button
5. Select `main` branch and click **Run workflow**
6. Monitor the job progress and check for success

### Option 2: Wait for Scheduled Run
- The workflow is scheduled to run daily at **11:00 UTC** (1 hour after Albion's maintenance)
- Next scheduled run: Check the **Actions** tab for the next scheduled date

## What to Expect

### Successful Run (Desired Outcome)
1. **Download stage**: Should show "Testing:" messages for candidate URLs
2. **Found working URL**: Message indicating a valid installer URL was found
3. **Download progress**: Shows file size (typically 1-3 GB)
4. **Installation**: Installer runs and game files are extracted
5. **GameData location**: Successfully locates the extracted GameData directory
6. **Data extraction**: Python script decrypts and converts .bin files to XML/JSON
7. **Git commit**: New files are committed and pushed to `data/` directory
8. **Job completion**: Green checkmark ✅

### Signs of Success
- The workflow takes **15-25 minutes** to complete
- XML and JSON files appear in the `data/` directory
- A new commit appears in the git history with message "chore: update Albion Online game data"
- GitHub Actions shows a green checkmark for the job

## If the Test Fails

### Check the Logs
1. Click on the failed job
2. Expand the **"Download official Albion Online installer"** step
3. Look for:
   - Which URLs were tested
   - Which URL returned HTTP 200 (success)
   - Any error messages about connectivity or file size

### Common Issues & Solutions

#### Issue: "Unable to download the official Albion Online installer from any candidate URL"
**Cause**: None of the generated timestamps match available builds

**Solution**:
1. Check [Albion's official launcher](https://albiononline.com) for current version
2. Try to find the build timestamp from recent APK releases at `https://live.albiononline.com/clients/`
3. Update the most recent timestamp in the workflow:
   ```powershell
   $candidateUrls += "$baseUrl/YYYYMMDDHHMMSS/albion-online-setup.exe"  # Update this line
   ```
4. Test locally if possible:
   ```powershell
   # Quick test of a URL
   Invoke-WebRequest -Uri "https://live.albiononline.com/clients/YYYYMMDDHHMMSS/albion-online-setup.exe" -Method Head
   ```

#### Issue: "Albion Online GameData directory was not found after installation"
**Cause**: Installer succeeded but GameData wasn't extracted properly

**Solution**:
1. Check if the launcher properly downloaded game files (may need internet connection)
2. Increase timeout for GameData search in workflow (currently 15 minutes)
3. Check if Windows permissions allow file creation in temporary directories

#### Issue: "Downloaded Albion installer is unexpectedly small"
**Cause**: CDN returned an error page instead of the actual installer

**Solution**:
1. Verify the timestamp in the URL is correct
2. Check if the CDN URL format has changed
3. Try the URL manually in a browser to verify

## Success Validation

After a successful run, verify:

```bash
# Check git log shows new commits
cd path/to/repo
git log --oneline -1

# Check data directory has new files
ls -la data/

# Verify XML and JSON files exist
ls data/*.xml | head -5
ls data/*.json | head -5
```

## Monitoring Future Runs

The workflow is configured to:
- **Run automatically**: Every day at 11:00 UTC
- **Adapt automatically**: Generate timestamps from the last 30 days
- **Provide feedback**: Log progress and errors to GitHub Actions

## Support & Troubleshooting

If issues persist:
1. Check the latest Albion Online build timestamp
2. Update `.albion-builds.txt` with the new timestamp
3. Create an issue with the full job logs attached
4. See `WORKFLOW_FIX_SUMMARY.md` for technical details

## Related Files

- `.github/workflows/update-albion-data.yml` - Main workflow definition
- `.albion-builds.txt` - Known-working build timestamps
- `WORKFLOW_FIX_SUMMARY.md` - Technical documentation
- `app.py` - Decryption and extraction script
