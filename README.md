# albiondata-bin-dumper.py
Decrypts Albion Online files, extracts data, and organizes into readable formats

## Installation

Before starting the installation, make sure you have Python 3.10 or a later version installed on your system. Then, follow the steps below:

1. Install PDM by following the instructions available on [the official PDM website](https://pdm-project.org/latest/#recommended-installation-method).

2. Run the following command to install the project dependencies:

   ```bash
   pdm install
    ```

3. After installation is complete, execute the following command to start:

   ```bash
   pdm run decrypt
    ```

    Optionally, you can add the base directory as an argument to the decrypt command using either **-d** or **--main-game-folder**:

   ```bash
   pdm run decrypt -d <path_to_base_directory>
    ```

    or


   ```bash
   pdm run decrypt --main-game-folder <path_to_base_directory>
    ```

    Replace <path_to_base_directory> with the absolute path of the directory to traverse.

To write the extracted files directly into a repository directory instead of a timestamped dump directory:

```bash
pdm run decrypt --main-game-folder <path_to_base_directory> --output ./data --flat-output
```

## GitHub Actions

The `Update Albion Online data` workflow downloads Albion Online with SteamCMD, decrypts the `StreamingAssets/GameData` `.bin` files, replaces the repository's `data/` directory, removes the downloaded game, and commits the extracted XML and JSON files.

- Runs automatically daily at 11:00 UTC, one hour after the usual 10:00 UTC Albion Online maintenance window.
- Can also be started manually with **Actions > Update Albion Online data > Run workflow**.
- Requires repository Actions permission to read and write repository contents.
- The workflow uses Steam application ID `761890` and GitHub-hosted Windows runners.

## Disclaimer

This code is purely for fun, and I am aware that it might not be the best-written code. If someone messes up with this code, I cannot be held responsible for any consequences.

## License

This project is licensed under the MIT License - see the LICENSE file for details