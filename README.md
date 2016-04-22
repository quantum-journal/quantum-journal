# LaTeX document class for Quantum

`quantumarticle` is the document class for typsetting articles in Quantum.

## Usage

To use it, download the latest version of `quantumarticle.cls` from above and put it into the same folder as your main LaTeX source file.
Then, simply change the document class to `quantumarticle` in the preamble of your document.

    \documentclass[your options]{quantumarticle}

## Compatibility

The `quantumarticle` class tries to be **maximally compatible** with existing document classes, such as, `article`, `revtex`, `iopart`, and `elsarticle`. It supports all standard options, like `twocolumn`, `onecolumn`, `titlepage`, as well as the standard syntax for defining the title page with the `\author`, `\address`, and `\affiliation` commands and the `abstract` environment.

If you encouter any problems, please write an email including a minimal working example that illustrates the problem to quantumarticle@quantum-journal.org

## Copyright

Copyright 2016
Christian Gogolin and Quantum - the open quantum journal

`quantumarticle.cls` is derived from `article.cls` available from
https://www.ctan.org/pkg/article

It may be distributed and/or modified under the
conditions of the LaTeX Project Public License, either version 1.3c
of this license or (at your option) any later version.
The latest version of this license is in
http://www.latex-project.org/lppl.txt
and version 1.3c or later is part of all distributions of LaTeX
version 2005/12/01 or later.
