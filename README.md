# LaTeX document class for Quantum

`quantumarticle` is the document class for typsetting articles in Quantum.

## Installing `{quantumarticle}`

The `quantumarticle` class is provided with install scripts for bash and PowerShell. These scripts should work for Windows 7 or later with MiKTeX, or for TeX Live with Linux or macOS / OS X. To install the class into your user-local LaTeX directory from within bash:

```bash
$ cd quantum-journal/
$ ./install.sh
```

Similarly, under PowerShell:

```powershell
PS > cd quantum-journal/
PS > ./install.ps1
```

To manually install ``{quantumarticle}``, copy ``quantumarticle.cls`` to ``texmf/tex/latex/quantumarticle`` within your home directory (``~`` under Linux and macOS / OS X, or typically ``C:\Users\``*``your username``*) under Windows) and run ``texhash`` (TeX Live) or ``initexmf --update-fndb`` (MiKTeX).

To test that the installation completed successfull, copy ``quantum-template.tex`` to another directory and compile it as normal.

## Usage

To use it, download the latest version of `quantumarticle.cls` from above and put it into the same folder as your main LaTeX source file.
Then, simply change the document class to `quantumarticle` in the preamble of your document.

    \documentclass[your options]{quantumarticle}

## Compatibility

The `quantumarticle` class tries to be **maximally compatible** with existing document classes, such as, `article`, `revtex`, `iopart`, and `elsarticle`. It supports all standard options, like `twocolumn`, `onecolumn`, `titlepage`, as well as the standard syntax for defining the title page with the `\author`, `\address`, and `\affiliation` commands and the `abstract` environment.

If you encouter any problems, please write an email including a minimal working example that illustrates the problem to quantumarticle@quantum-journal.org

## Contributing

In case you encounter problems using the article class please consider opening a bug report in our bug-tracker under https://github.com/cgogolin/quantum-journal/issues or contact us via email under latex@quantum-journal.org.

Improvements submitted as pull requestes are very much appreciated! Please submit them agains the develop branch.

## Copyright

Copyright 2016
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
