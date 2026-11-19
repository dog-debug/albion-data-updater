# Albion Data Updater - Quick Start Guide

## 🎯 What Was Fixed

Your GitHub Actions workflow was **failing to download the Albion Online installer** because the CDN URL contained an outdated build timestamp. The fix implements an **intelligent fallback mechanism** that automatically discovers and uses valid installer URLs.

## ✅ Changes Made

### Core Fixes
1. **Workflow Improvement** (`51f3074`)
   - Replaced hardcoded installer URL with dynamic timestamp generation
   - Implements 30-day rolling window to find valid builds
   - Uses HTTP HEAD requests for quick URL validation
   - Better error messages and logging

2. **Documentation** (`068e891`, `98d083c`)
   - `WORKFLOW_FIX_SUMMARY.md` - Technical explanation
   - `TESTING_GUIDE.md` - Testing and troubleshooting instructions
   - `.albion-builds.txt` - Known-working build timestamp registry

3. **Diagnostic Tools** (`fb100d0`)
   - `scripts/find-latest-build.ps1` - Script to discover new builds

## 📋 How to Test

### Quick Test (Recommended)
1. Go to [GitHub Actions](https://github.com/dog-debug/albion-data-updater/actions)
2. Select "Update Albion Online data" workflow
3. Click "Run workflow" → "Run workflow"
4. Wait 15-25 minutes for completion

### Expected Success Indicators
- ✅ Installer downloads successfully (1-3 GB)
- ✅ GameData directory is located and extracted
- ✅ XML/JSON files appear in `data/` directory
- ✅ New commit created with updated game data
- ✅ Green checkmark on workflow completion

## 🔧 If Testing Fails

### Step 1: Check the Logs
1. Click on the failed workflow run
2. Expand "Download official Albion Online installer" step
3. Look for which URLs were tested and their status codes

### Step 2: Discover Latest Build
Run the diagnostic script:
```powershell
cd path/to/repo
.\scripts\find-latest-build.ps1
```

This will:
- Search the CDN for available installer builds
- Report any valid timestamps found
- Provide instructions for updating the workflow

### Step 3: Update if Needed
If a new build is found, update the workflow:
1. Edit `.github/workflows/update-albion-data.yml`
2. Add the new timestamp to the `$candidateUrls` array:
   ```powershell
   $candidateUrls += "$baseUrl/YYYYMMDDHHMMSS/albion-online-setup.exe"
   ```
3. Commit and push
4. Retest

## 📁 Key Files

| File | Purpose |
|------|---------|
| `.github/workflows/update-albion-data.yml` | Main workflow definition |
| `app.py` | Decryption and extraction script |
| `.albion-builds.txt` | Known-working build timestamps |
| `scripts/find-latest-build.ps1` | Build discovery utility |
| `WORKFLOW_FIX_SUMMARY.md` | Technical details |
| `TESTING_GUIDE.md` | Full testing instructions |

## 🤝 How It Works

The workflow now:

1. **Generates candidate URLs** from timestamps across the last 30 days
2. **Tests each URL** efficiently with HTTP HEAD requests
3. **Downloads from the first valid URL** found
4. **Falls back gracefully** with clear error messages if all URLs fail

This ensures the workflow automatically adapts to new Albion Online builds without requiring manual updates.

## 📊 Build History

Recent known-working builds (tracked in `.albion-builds.txt`):
- `20261102100206` - November 2, 2026 (Latest)

## 🚀 Next Steps

1. ✅ Triggered workflow to test the fix
2. ⏳ Monitor workflow completion
3. 📝 Verify new game data files are created
4. 🔄 Set up monitoring for future runs

## 📞 Support

For more detailed information, see:
- **Technical Details**: `WORKFLOW_FIX_SUMMARY.md`
- **Testing Instructions**: `TESTING_GUIDE.md`
- **GitHub Workflows**: [Actions Tab](https://github.com/dog-debug/albion-data-updater/actions)

---

**Latest Commits:**
- `fb100d0` - Add build discovery script
- `98d083c` - Add comprehensive testing guide
- `068e891` - Add workflow documentation
- `51f3074` - Fix: improve installer URL discovery

