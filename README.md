[![Build Status](https://travis-ci.org/quantum-journal/quantum-journal.svg?branch=master)](https://travis-ci.org/quantum-journal/quantum-journal)

# LaTeX document class for Quantum

This is version 6.1 of `quantumarticle`, the document class for typesetting articles in Quantum - the open journal for quantum science.

[Click here](https://raw.githubusercontent.com/quantum-journal/quantum-journal/master/quantumarticle.cls) to download the latest stable version.

[More information](https://raw.githubusercontent.com/quantum-journal/quantum-journal/master/quantum-template.pdf) on using quantumarticle and on typesetting manuscripts for Quantum can be found in the accompanying template.

[Extra information on the Quantum bibstyle](https://raw.githubusercontent.com/quantum-journal/quantum-journal/master/quantum-bibliographystyle-demo.pdf) can be found in the bibstyle demo.

[Documentation](https://raw.githubusercontent.com/quantum-journal/quantum-journal/master/quantumarticle.pdf) of all class options is also provided.


## Installation and usage

To use the `quantumarticle` document class with LaTeX simply start your document with the line:

```latex
\documentclass[your options]{quantumarticle}

```
Before you can do this however, you must make `quantumarticle.cls` accessible to your LaTeX compiler. You have several options for doing this:

1. The `quantumarticle` class is provided with install scripts for bash and PowerShell. These scripts should work for Windows 7 or later with MiKTeX, or for TeX Live with Linux or macOS / OS X. To install the class into your user-local LaTeX directory you would first clone this git repository `git clone https://github.com/quantum-journal/quantum-journal.git quantum-journal` and them from within bash execute:
 ```bash
 $ cd quantum-journal/
 $ ./install.sh
 ```
 Similarly, under PowerShell:
 ```powershell
 PS > cd quantum-journal/
 PS > ./install.ps1
 ```

2. Alternatively you can use `quantumarticle.cls` without installing it by simply downloading it directly via [this link](https://raw.githubusercontent.com/quantum-journal/quantum-journal/master/quantumarticle.cls) and putting it in the same folder as your main LaTeX source file. This can be the most convenient option if you are working on a manuscript together with collaborators that do not want to install `quantumarticle.cls` and are exchanging the source files of your manuscript via email or cloud storage services. When you upload your manuscript to the arXiv you will anyway have to include `quantumarticle.cls` along with other source files.

3. To manually install `quantumarticle`, you can either clone this git repository or download `quantumarticle.cls` directly via [this link](https://raw.githubusercontent.com/quantum-journal/quantum-journal/master/quantumarticle.cls) and then copy the `quantumarticle.cls` file to `texmf/tex/latex/quantumarticle` within your home directory (under Linux, macOS, and OS X `~/`, or under Windows typically `C:\Users\[your username]`) and run `texhash` (TeX Live) or `initexmf --update-fndb` (MiKTeX).

4. Finally, you can use `quantumarticle.cls` without even downloading it at all on the collaborative writing platform [overleaf](https://www.overleaf.com/) by starting your project from the `quantumarticle` [template](https://www.overleaf.com/latex/templates/template-for-submission-to-quantum-journal/gsjgyhxrtrzy).

## Dependencies

`quantumarticle.cls` should work with any reasonably recent LaTeX distribution. It further requires the following packages: `xkeyval`, `etoolbox`, `geometry`, `xcolor`, `fancyhdr`, `tikz`, `hyperref`, `ltxgrid` and `ltxcmds` (often distributed along with revtex, in texlive for example as part of `texlive-publishers`), as well as at least either `lmodern` or `type1ec`. We recommend to have `natbib` and at least one of `bbm` or `dsfont` installed. All of these should be included in the full install variant of your LaTeX distribution (for example `texlive-full`).

## Compatibility

The `quantumarticle` class tries to be **maximally compatible** with existing document classes, such as, `article`, `revtex`, `iopart`, and `elsarticle`. It supports all standard options, like `twocolumn`, `onecolumn`, `titlepage`, as well as the standard syntax for defining the title page with the `\author`, `\address`, and `\affiliation` commands and the `abstract` environment.

## Beta features

In addition, this document class comes bundled with two new extras (currently in beta phase):

1. The quantum-lyx-template.lyx LyX layout, which allows you to generate the LaTeX source of your quantumarticle manuscript with the LyX document processor.

2. The quantum.bst bibliography style for BibTeX, see the corresponding demo for usage details.

## Changelog

### New in v6.1


* Fix for long urls in bibliography items not breaking correctly.

* Added explanation of the difference between regular and [shotDOIs](https://shortdoi.org/) and why the latter cannot be used in bibliographies
* Further increased hyphen penalty of title

### New in v6.0

* introduced the Quantum bibstyle `quantum.bst` together with the demo file `quantum-bibliographystyle-demo`
* Removed the quantum-plots package, which is superseeded by [rsmf](https://pypi.org/project/rsmf/)
* Fixed typo in allowfontchangeintitle option

### New in v5.1

* fix for workaround in ltxgrid no longer being necessary and, on the contrary, causing an error under TeXLive 2020, with revtex/ltygrid 4.2e/4.2d
* improved typesetting of authors if titlepage is used
* added explanation for how to use BibTeX on the arXiv
* fixed equations in template

### New in v5.0:

* force users to specify a paper size to prevent unexpected behavior
* option processing is now done exclusively by means of xkeyval
* improved compatibility with frequently used LaTeX document classes
* improved/added options for using this document class for manuscripts not intended for submission to Quantum
* documents not intended for submission to Quantum can now be compiled with compilers different from PdfLaTeX (e.g. LuaLaTeX)
* use https in links when possible
* prevent usage of the `\today` macro in `\date` to avoid changing dates in documents when they are re-compiled on the arXiv
* enforce that users put `\pdfoutput=1` (as recommended by the arXiv) to prevent problems with multi-line hyper links
* improved error messages
* fixed a bug that lead to the title not being centered with the `titlepage` option
* better layout of titles
* fixed various bugs in option processing
* the document class is now documented in `quantumarticle.pdf`
* introduced the plotting notebook `quantum-plots.ipynb` as a beta feature
* introduced the LyX template `quantum-lyx-template.lyx` as a beta feature

## Contributors

Developed by: Christian Gogolin, Cassandra Granade, Johannes J. Meyer, and Victor V. Albert

With contributions from: Shahnawaz Ahmed, Andrey Rakhubovsky, liantze,
Abhinav Deshpande, and David Wierichs

## Contributing

In case you encounter problems using the article class please consider opening a bug report in our [bug-tracker on GitHub](https://github.com/quantum-journal/quantum-journal/issues).
You can also contact us via email under latex@quantum-journal.org, but it may take significantly longer to get a response.
In any case we need the full source of a document that produces the problem and the log file showing the error to help you.

Improvements submitted as pull requests against the `develop` branch are very much appreciated!

## Copyright

Copyright 2017, 2018, 2019, 2020, 2021, 2022
Verein zur Förderung des Open Access Publizierens in den Quantenwissenschaften
(http://quantum-journal.org/about/)

`quantumarticle.cls` is derived from `article.cls` available from
https://www.ctan.org/pkg/article

It may be distributed and/or modified under the
conditions of the LaTeX Project Public License, either version 1.3c
of this license or (at your option) any later version.
The latest version of this license is in
http://www.latex-project.org/lppl.txt
and version 1.3c or later is part of all distributions of LaTeX
version 2005/12/01 or later.

[comment]: # (To submit to the overleaf gallery: push, open the project, go to Journals and Services and click Submit to Overleaf Gallery. To submit to sharelatex: write them an email)
