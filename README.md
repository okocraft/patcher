# patcher

Scripts for applying/creating patches.

## Usage

### Basic usage

#### Preparing sources

- Create a `source` directory
- Place source files in the `source` directory
- `./patcher apply` (alias: `./patcher app`) to initialize the working directory (`work` directory)

#### Modifying sources and creating patches

- Modify sources in the `work` directory
- Commit changes using Git under the `work` directory
- Move the project's root directory and run `./patcher rebuild` (alias: `./patcher reb`) to create patches

#### Applying patches

To reapply patches created by the above steps, run `./patcher app`. It not only patches the source, but also stores commit information.

**NOTE**: Once executed, any uncommitted changes in the work directory will be lost.

### Changing source/patches/work directory

#### Windows

Open `patcher.bat` and change values as follows:

```bat
set SOURCE_DIR_NAME=new_source_directory_name
set PATCH_DIR_NAME=new_patch_directory_name
set WORK_DIR_NAME=new_work_directory_name
```

If you want to use other directories that is outside the project, set the appropriate path to `SOURCE_DIR`/`PATCH_DIR`/`WORK_DIR` values.

## Requirements

- Git
- Windows

## License

This project is under the Apache License version 2.0. Please see [LICENSE](LICENSE) for more info.

Copyright © 2024, OKOCRAFT
