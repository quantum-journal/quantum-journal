# LaTeX document class for Quantum

`quantumarticle` is the document class for typsetting articles in Quantum.

## Installation and usage

To use the `quantumarticle` document class with LaTeX simply start your documment with the line:

```latex
\documentclass[your options]{quantumarticle}

```
Before you can do this however, you must install `quantumarticle.cls`. You have several options for doing this:

1. The `quantumarticle` class is provided with install scripts for bash and PowerShell. These scripts should work for Windows 7 or later with MiKTeX, or for TeX Live with Linux or macOS / OS X. To install the class into your user-local LaTeX directory from within bash:
 ```bash
 $ cd quantum-journal/
 $ ./install.sh
 ```
 Similarly, under PowerShell:
 ```powershell
 PS > cd quantum-journal/
 PS > ./install.ps1
 ```

2. To manually install `quantumarticle`, copy `quantumarticle.cls` to `texmf/tex/latex/quantumarticle` within your home directory (under Linux, macOS, and OS X `~/`, or under Windows typically `C:\Users\[your username]`) and run `texhash` (TeX Live) or `initexmf --update-fndb` (MiKTeX).

3. Alternatively you can use `quantumarticle.cls` without installing it by simply putting it in the same folder as your main LaTeX source file. This can be the most convenient option if you are working on a manuscript together with collaborators that do not want to install `quantumarticle.cls` and are exchaning the source files of your manuscript via email of cloud storage services.

4. Finally, you can use `quantumarticle.cls` without even downloading it at all on the collaborative writing platform [overleaf](https://www.overleaf.com/) by starting you project from the `quantumarticle` [template](https://www.overleaf.com/latex/templates/template-for-submission-to-quantum-journal/gsjgyhxrtrzy) as well as with the [ShareLaTeX](https://www.sharelatex.com/project) online LaTeX editor by using the `quantumarticle` [template](https://www.sharelatex.com/templates/5851932b93a02abc513710f3) there.

## Compatibility

The `quantumarticle` class tries to be **maximally compatible** with existing document classes, such as, `article`, `revtex`, `iopart`, and `elsarticle`. It supports all standard options, like `twocolumn`, `onecolumn`, `titlepage`, as well as the standard syntax for defining the title page with the `\author`, `\address`, and `\affiliation` commands and the `abstract` environment.

## Contributing

In case you encounter problems using the article class please consider opening a bug report in our [bug-tracker on github](https://github.com/cgogolin/quantum-journal/issues) or contact us via email under latex@quantum-journal.org.

Improvements submitted as pull requests against the `development` branch are very much appreciated!

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
