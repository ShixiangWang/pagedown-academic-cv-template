# Data Driven Pagedown Rendered Academic CV

This repo provides source-code and templates for automatically generate academic CV with CSV and Markdown.

## Usage

Prepare the following 4 files.

- [positions.csv](positions.csv) - Life experiences.
- [profile.csv](profile.csv) - Scholar profile information.
- [aside.md](aside.md) - Text add to side bar.
- [intro.md](intro.md) - Text to introduce yourself.

You can modify the provided 4 files (generated from Guangchuang Yu), then run `run.R`.
The generated CV html file will be located at `cv` directory.

You can move it to directory `docs` for rendering it with GitHub pages.

**NOTE**: the `run.R` can be called in other path if you provide the template directory path
correctly.

e.g.,

```sh
# Assume you create a directory
# and prepare the 4 necessary files
# You can run the script in this directory by
/anypath/run.R /anypath/template
# the anypath here is the location of this repo in your local machine
```

## Preview

Based on this repo, I create a CV for myself at <https://shixiangwang.github.io/cv-shixiang/>.

## Thanks to

This repo is based on work from [Guangchuang Yu](https://github.com/GuangchuangYu/cv) and [nstrayer](https://github.com/nstrayer/cv).


## LICENSE

MIT@2020
