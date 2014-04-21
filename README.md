# Getting and Cleaning Data project

This readme gives an overview of the project structure and the scripts.

## Scripts

### `download.R`

 * downloads the data for the project, saving it as `dataset.zip` (skipped if `dataset.zip` already exists),
 * extracts it into the working directory.

The zip has a single root directory `UCI HAR Dataset`, so it will not pollute the working directory with individual files.
This script is for convenience only, downloading and extracting may be performed manually, too.

### `run_analysis.R`

The goal of this script is to produce the tidy dataset.  For that end it

 * reads the raw data from various files in the `UCI HAR Dataset` directory (relative to the working directory),
 * performs the merging and cleaning steps as per the project specification,
 * saves the tidy dataset in CSV format as `tidy.txt` in the working directory.

This script assumes the dataset zip file is already extracted and data files are present in the `UCI HAR Dataset` directory.

It requires the [http://cran.r-project.org/web/packages/reshape2/index.html](reshape2) R package.

## Code book

The code book for the project is in `CodeBook.md`, which describes the variables, the data, and transformations performed by `run_analysis.R`.
