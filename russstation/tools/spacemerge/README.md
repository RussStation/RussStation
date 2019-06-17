# spacemerge

Spacemerge consumes `mergestrategies.json` to make assumptions on what can be safely git checked out so that only select files need to be manually resolved when merging between RussStation and /tg/station.

## why

RussStation and /tg/station's respective commit histories are unrelated. Within that, git has to scan the files directly to check for conflicts. Any difference, including line endings, will cause the file to be marked as conflicting. This leads to a *significant* number of conflicting files. To make keeping /tg/station upstream of RussStation feasible, this tool has been built to offload as much of the work resolving merge conflicts to an automated process as possible.

## how

First run `npm install` to download the required dependencies. Ensure that `mergestrategies.json` is configured to your use case. Open a terminal to the root folder of the station. Call spacemerge from within the root folder using the following format.

```
Usage: node path/to/spacemerge [options]

Options:
  --verbose           output all responses from git
  --close-on-error    stop processing git checkouts and exit if one fails
  -h, --help          display command line options (currently set)
```

## mergestrategies.json?

`mergestrategies.json` is a JSON object where the keys are the folders to be scanned, and the values are the strategies to be used. Strategies are defined in `spacemerge.js`.

```
{
    "tools": "THEIRS",
    "tgui": "THEIRS",
    "strings": "THEIRS",
...
}
```
To ignore a folder, simply leave it out.