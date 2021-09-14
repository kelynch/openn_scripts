# README for `openn_scripts`

This is a repository for some ad hoc scripts that were written to generate outputs for OPenn from PUL collections in Bibdata and Figgy IIIF manifests.

## Instructions

1. To generate descriptive metadata (marc XML), generate a manifest of MMS IDs from the catalog and in the same format as the [example manifest](bibs_manifest.example) and name the file `bibs_manifest`:
```bash
./curl_bibs.sh
```
This will generate XML files of the descriptive metadata for the catalog records referenced in `bibs_manifest`, one file per MMS ID.

2. To generate OPenn structural metadata spreadsheets, download the IIIF manifests for the Figgy objects and run the script against them one at a time from the command line, example as follows:
```bash
ruby get_struct_mds.rb 4821057.json
```

---

[Example of data load in Google Drive for OPenn](https://drive.google.com/drive/folders/1oOc__RgpY6AzpIlSuS0EYW__nu_I67Qj)
