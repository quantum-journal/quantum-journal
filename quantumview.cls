%%
%% This is file `quantumview.cls',
%% it provides the quantumview class for typesetting perspective articles in
%% Quantum - the open journal for quantum science
%%
%% Copyright 2020, 2021
%% Verein zur Förderung des Open Access Publizierens in den Quantenwissenschaften
%% (https://quantum-journal.org/about/)
%% 
%% It is derived from `quantumarticle.cls' available from Quantum.
%%
%% It may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3c
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.3c or later is part of all distributions of LaTeX
%% version 2005/12/01 or later.
%% 
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\def\quantumviewversion{5.1}
\ProvidesClass{quantumview}
[2020/10/27 v\quantumviewversion
class for Quantum - the open journal for quantum science (https://quantum-journal.org)]
\RequirePackage{xkeyval}
\RequirePackage{etoolbox}

\newcommand*\@ptsize{}

\newtoggle{@restonecol}
\newtoggle{@titlepage}
\togglefalse{@titlepage}

\newtoggle{@html}
\togglefalse{@html}
\DeclareOptionX{html}{\toggletrue{@html}}

\setlength\paperheight{297mm}%
\setlength\paperwidth{210mm}

\renewcommand*\@ptsize{1}

\ProcessOptionsX

\input{size1\@ptsize.clo}

\newcommand{\@tag}[2]{<#1>#2</#1>}

\iftoggle{@html}{\renewcommand*\familydefault{\ttdefault}}{}

\AtBeginDocument{
	% avoid bitmap fonts by loading lmodern or at least checking for cm-super
	\IfFileExists{lmodern.sty}{
		\RequirePackage{lmodern}
	}{}
	% Define a revtex-style openone symbol
	\IfFileExists{bbm.sty}{
		\RequirePackage{bbm}
		\DeclareRobustCommand\openone{\mathbbm{1}}
	}{
		\IfFileExists{dsfont.sty}{
			\RequirePackage{dsfont}
			\DeclareRobustCommand\openone{\mathds{1}}
		}{
			% This uses a similar technique to {revtex4-1}'s openone,
			% namely two overstruck numeral 1s, but implemented using mboxes
			% and math kerning as suggested by The Comprehensive LaTeX Symbol List.
			\DeclareRobustCommand\openone{{\mbox{\small1}\mkern-5.5mu1}}
		}
	}
	\RequirePackage{xcolor}
	\definecolor{quantumviolet}{HTML}{53257F} %Quantum violet
	\definecolor{quantumgray}{HTML}{555555} %Quantum gray
	\iftoggle{@html}{
		\RequirePackage{verbatim}
	}{}
}

\AfterEndPreamble{
	\iftoggle{@html}{
		\renewcommand{\emph}[1]{\@tag{em}{#1}}
		\renewcommand{\textit}[1]{\@tag{i}{#1}}
		\renewcommand{\textbf}[1]{\@tag{b}{#1}}
		\renewcommand{\textsuperscript}[1]{\@tag{sup}{#1}}
		\renewcommand{\textsubscript}[1]{\@tag{sub}{#1}}
		\renewcommand{\cite}[1]{{\textbackslash}cite\{#1\}}
		\renewcommand{\section}[1]{\noindent\@tag{h1}{#1}\\ }
		\renewcommand{\subsection}[1]{\noindent\@tag{h2}{#1}\\ }
		\renewcommand{\subsubsection}[1]{\noindent\@tag{h3}{#1}\\ }
		\renewcommand{\paragraph}[1]{\noindent\@tag{b}{#1}}
		\renewenvironment{equation}
			{\endgraf \noindent \$\$ \verbatim}
			{\endverbatim \$\$ \endgraf}
		\renewenvironment{align}
			{\endgraf \noindent \$\$ \verbatim}
			{\endverbatim \$\$ \endgraf}
		\renewenvironment{eqnarray}
			{\endgraf \noindent \$\$ \verbatim}
			{\endverbatim \$\$ \endgraf}
		% This solution for itemize and enumerate is due to David Carlisle from tex.stackexchange
		\def\itemize{%
			\par\noindent <ul>\let\zz\relax
			\let\olditem\item
			\def\item{\zz\par\indent<li>\def\zz{\ifhmode\unskip\fi</li>\par}}
		}
		\def\enditemize{\zz\endgraf\noindent</ul>\par \let\item\olditem}
		\def\enumerate{%
			\par\noindent <ol>\let\zz\relax
			\let\olditem\item
			\def\item{\zz\par\indent<li>\def\zz{\ifhmode\unskip\fi</li>\par}}
		}
		\def\endenumerate{\zz\endgraf\noindent</ol>\par \let\item\olditem}
		
		\def\@@addnewlinebetween#1{#1 \\ \noindent }
		\def\@affiliationsonly{\forlistloop{\@@addnewlinebetween}{\affiliations}}
		\renewcommand{\@maketitle}{%
			\noindent {\footnotesize Title:} \\
			\noindent {\@title} \\
			\noindent {\footnotesize Author:} \\
			\noindent \@authorsonly \\
			\noindent {\footnotesize Affiliations:} \\
			\noindent \@affiliationsonly \\
		}
}{}
}

\setcounter{topnumber}{2}
\renewcommand*\topfraction{.7}
\setcounter{bottomnumber}{1}
\renewcommand*\bottomfraction{.3}
\setcounter{totalnumber}{3}
\renewcommand*\textfraction{.2}
\renewcommand*\floatpagefraction{.5}
\setcounter{dbltopnumber}{2}
\renewcommand*\dbltopfraction{.7}
\renewcommand*\dblfloatpagefraction{.5}

\def\ps@headings{%
\let\@oddfoot\@empty
\def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
\let\@mkboth\markboth
\def\sectionmark##1{%
	\markright {\MakeUppercase{%
			\ifnumgreater{\c@secnumdepth}{\m@ne}
				{\thesection\quad}
				{}
			##1}}%
	}%
}%

\def\ps@myheadings{%
	\let\@oddfoot\@empty\let\@evenfoot\@empty
	\def\@evenhead{\thepage\hfil\slshape\leftmark}%
	\def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
	\let\@mkboth\@gobbletwo
	\let\sectionmark\@gobble
	\let\subsectionmark\@gobble
}


\newcommand\maketitle{\par
\begingroup
\renewcommand\thefootnote{\@fnsymbol\c@footnote}%
\def\@makefnmark{\rlap{\@textsuperscript{\normalfont\@thefnmark}}}%
\long\def\@makefntext##1{\parindent 1em\noindent
\hb@xt@1.8em{%
\hss\@textsuperscript{\normalfont\@thefnmark}}##1}%
\global\@topnum\z@   % Prevents figures from going at top of page.
\@maketitle
\thispagestyle{fancy}%\@thanks
\endgroup
\setcounter{footnote}{0}%
\global\let\thanks\relax
\global\let\maketitle\relax
\global\let\@maketitle\relax
%  \global\let\@thanks\@empty
%  \global\let\@author\@empty
%  \global\let\@date\@empty
%  \global\let\@title\@empty
\global\let\title\relax
\global\let\author\relax
\global\let\date\relax
\global\let\and\relax
}

\def\@maketitle{%
	\sffamily
	\null
	\let \footnote \thanks
	\noindent%
	\begin{minipage}{\textwidth}%
          \iftoggle{@titlepage}{\centering}{}%
          \noindent{\huge\hyphenpenalty=5000 \@printtitle\par}%
        \end{minipage}%
	\vskip 1.5em%
	\iftoggle{@titlepage}{}{\begin{flushleft}}%
		\noindent \@printauthors
	\iftoggle{@titlepage}{}{\end{flushleft}}%
	\vskip 1em%
	\noindent\@printaffiliations
	\vskip 0em%
	\ifdefempty{\@date}{}{\noindent{\footnotesize\color{quantumgray}\@date}}%
	\par
	\vskip 1.5em
	\makeatletter%
	\begingroup
	\hypersetup{%
		pdftitle={\detokenize\expandafter{\@title}},
		pdfauthor={\@authorsonly},
		pdfkeywords={\@keywords},
		pdfcreator={LaTeX with hyperref package and class quantumview \csname ver@quantumview.cls\endcsname},
	}%
	\endgroup
	\makeatother%
}

\setcounter{secnumdepth}{3}
\newcounter {part}
\newcounter {section}
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand*\thepart {\@Roman\c@part}
\renewcommand*\thesection {\@arabic\c@section}
\renewcommand*\thesubsection   {\thesection.\@arabic\c@subsection}
\renewcommand*\thesubsubsection{\thesubsection.\@arabic\c@subsubsection}
\renewcommand*\theparagraph    {\thesubsubsection.\@arabic\c@paragraph}
\renewcommand*\thesubparagraph {\theparagraph.\@arabic\c@subparagraph}
\newcommand\part{%
	\ifbool{@noskipsec}{\leavevmode}{}
	\par
	\addvspace{4ex}%
	\boolfalse{@afterindent}
	\secdef\@part\@spart}

\def\@part[#1]#2{%
\ifnumgreater{\c@secnumdepth}{\m@ne}
	{\refstepcounter{part}\addcontentsline{toc}{part}{\thepart\hspace{1em}#1}}
	{\addcontentsline{toc}{part}{#1}}
{\parindent \z@ \raggedright
\interlinepenalty \@M
\normalfont
\ifnumgreater{\c@secnumdepth}{\m@ne}{\Large\bfseries \partname\nobreakspace\thepart\par\nobreak}{}
\huge \bfseries #2%
\markboth{}{}\par}%
\nobreak
\vskip 3ex
\@afterheading%
}

\def\@spart#1{%
	{\parindent \z@ \raggedright
			\interlinepenalty \@M
			\normalfont
			\huge \bfseries #1\par}%
	\nobreak
	\vskip 3ex
	\@afterheading}

\newcommand*\section{\@startsection {section}{1}{\z@}%
  {-3.5ex \@plus -1ex \@minus -.2ex}%
  {2.3ex \@plus.2ex}%
  {\normalfont\Large\sffamily}}

\newcommand*\subsection{\@startsection{subsection}{2}{\z@}%
	{-3.25ex\@plus -1ex \@minus -.2ex}%
	{1.5ex \@plus .2ex}%
	{\normalfont\large\sffamily}}

\newcommand*\subsubsection{\@startsection{subsubsection}{3}{\z@}%
	{-3.25ex\@plus -1ex \@minus -.2ex}%
	{1.5ex \@plus .2ex}%
	{\normalfont\normalsize\sffamily}}

\newcommand*\paragraph{\@startsection{paragraph}{4}{\z@}%
	{3.25ex \@plus1ex \@minus.2ex}%
	{-1em}%
	{\normalfont\normalsize\bfseries}}

\newcommand*\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
	{3.25ex \@plus1ex \@minus .2ex}%
	{-1em}%
	{\normalfont\normalsize\bfseries}}

\setlength\leftmargini{2.5em}
\leftmargin  \leftmargini
\setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}

\setlength\leftmarginv  {1em}
\setlength\leftmarginvi {1em}

\setlength  \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand*\theenumi{\@arabic\c@enumi}
\renewcommand*\theenumii{\@alph\c@enumii}
\renewcommand*\theenumiii{\@roman\c@enumiii}
\renewcommand*\theenumiv{\@Alph\c@enumiv}
\newcommand*\labelenumi{\theenumi.}
\newcommand*\labelenumii{(\theenumii)}
\newcommand*\labelenumiii{\theenumiii.}
\newcommand*\labelenumiv{\theenumiv.}
\renewcommand*\p@enumii{\theenumi}
\renewcommand*\p@enumiii{\theenumi(\theenumii)}
\renewcommand*\p@enumiv{\p@enumiii\theenumiii}
\newcommand*\labelitemi{\textbullet}
\newcommand*\labelitemii{\normalfont\bfseries \textendash}
\newcommand*\labelitemiii{\textasteriskcentered}
\newcommand*\labelitemiv{\textperiodcentered}
\newenvironment{description}
{\list{}{\labelwidth\z@ \itemindent-\leftmargin
		\let\makelabel\descriptionlabel}}
{\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
	\normalfont\bfseries #1}

\newenvironment{abstract}{%
	\ifdefempty{\maketitle}{\relax{}}{\maketitle}
	\vskip 1em \quotation%
}
{
	\endquotation\vskip 2em%
}

\newenvironment{verse}
{\let\\\@centercr
	\list{}{\itemsep      \z@
		\itemindent   -1.5em%
		\listparindent\itemindent
		\rightmargin  \leftmargin
		\advance\leftmargin 1.5em}%
	\item\relax}
{\endlist}

\newenvironment{quotation}
{\list{}{\listparindent 1.5em%
		\itemindent    \listparindent
		\rightmargin   \leftmargin
		\parsep        \z@ \@plus\p@}%
	\item\relax}
{\endlist}

\newenvironment{quote}
{\list{}{\rightmargin\leftmargin}%
	\item\relax}
{\endlist}

\newcommand*\appendix{\par
	\setcounter{section}{0}%
	\setcounter{subsection}{0}%
	\gdef\thesection{\@Alph\c@section}}
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\renewcommand*\theequation {\@arabic\c@equation}
\newcounter{figure}
\renewcommand*\thefigure {\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename\nobreakspace\thefigure}

\newenvironment{figure}
{\@float{figure}}
{\end@float}

\newenvironment{figure*}
{\@dblfloat{figure}}
{\end@dblfloat}

\newcounter{table}
\renewcommand*\thetable{\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename\nobreakspace\thetable}

\newenvironment{table}
{\@float{table}}
{\end@float}

\newenvironment{table*}
{\@dblfloat{table}}
{\end@dblfloat}

\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
	\vskip\abovecaptionskip
	\sbox\@tempboxa{#1: #2}%
	\ifdimgreater{\wd\@tempboxa}{\hsize}
		{#1: #2\par}
		{\global\boolfalse{@minipage}
		\hb@xt@\hsize{\hfil\box\@tempboxa\hfil}}%
	\vskip\belowcaptionskip}

\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}

\newcommand*\@pnumwidth{1.55em}
\newcommand*\@tocrmarg{2.55em}
\newcommand*\@dotsep{4.5}
\setcounter{tocdepth}{3}

% We use a trick from Ivan Andrus (https://stackoverflow.com/a/2785740)
% to hide the "\section*{Contents}" command from the table of contents
% to avoid getting an ugly duplication of the Contents header inside
% the table itself.
%
% This trick consists of temporarily redefining \addcontentsline to
% do nothing during the expansion of the arguments to \tocless.
\newcommand{\nocontentsline}[3]{}
\newcommand{\tocless}[2]{\bgroup\let\addcontentsline=\nocontentsline#1{#2}\egroup}
\newcommand\tableofcontents{%
	\tocless{\section*}{\contentsname
		\@mkboth{%
			\MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
	\@starttoc{toc}%
}

\newcommand*\l@part[2]{%	
	\ifnumgreater{\c@tocdepth}{-2}{\relax
		\addpenalty\@secpenalty
		\addvspace{2.25em \@plus\p@}%
		\setlength\@tempdima{3em}%
		\begingroup
		\parindent \z@ \rightskip \@pnumwidth
		\parfillskip -\@pnumwidth
		{\leavevmode
			\large \bfseries #1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
		\nobreak
		\endgroup
	}{}%
}

\newcommand*\l@section[2]{%
	\ifnumgreater{\c@tocdepth}{\z@}{
		\addpenalty\@secpenalty
		\addvspace{1.0em \@plus\p@}%
		\setlength\@tempdima{1.5em}%
		\begingroup
		\parindent \z@ \rightskip \@pnumwidth
		\parfillskip -\@pnumwidth
		\leavevmode \bfseries
		\advance\leftskip\@tempdima
		\hskip -\leftskip
		#1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
		\endgroup
	}{}%
}

\newcommand*\l@subsection{\@dottedtocline{2}{1.5em}{2.3em}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{3.8em}{3.2em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{7.0em}{4.1em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{10em}{5em}}

\newcommand\listoffigures{%
	\section*{\listfigurename}%
	\@mkboth{\MakeUppercase\listfigurename}%
	{\MakeUppercase\listfigurename}%
	\@starttoc{lof}%
}

\newcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{%
	\section*{\listtablename}%
	\@mkboth{%
		\MakeUppercase\listtablename}%
	{\MakeUppercase\listtablename}%
	\@starttoc{lot}%
}

\let\l@table\l@figure
% Declare a new \acknowledgements command for {revtex4-1}
% compatability.
\newcommand*{\acknowledgmentsname}{Acknowledgments}
\newcommand{\acknowledgments}[1]{%
	\section*{\acknowledgmentsname}%
	#1%
}

\newdimen\bibindent
\setlength\bibindent{1.5em}

\newenvironment{thebibliography}[1]
{%
  \makeatletter%
  \iftoggle{@noarxiv}{}{%
    \ltx@ifpackageloaded{natbib}{}{%
      \ltx@ifpackageloaded{biblatex}{
        \ClassWarning{quantumview}{Unfortunately quantumview cannot recommend the use of BibLaTeX due to incompatibilities between locally installed versions of BibLaTeX and the version used by the arXiv.}%
      }{%
        \ClassWarning{quantumview}{The quantumview class recommends generating the bibliography from a BibTeX file containing DOIs with natbib in order to ensure the generation of DOI hyperlinks}%
      }%
    }%
  }%
  \makeatother%
  \section*{\refname}%
  \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
  \list{\@biblabel{\@arabic\c@enumiv}}%
  {\settowidth\labelwidth{\@biblabel{#1}}%
    \leftmargin\labelwidth
    \advance\leftmargin\labelsep
    \@openbib@code
    \usecounter{enumiv}%
    \let\p@enumiv\@empty
    \renewcommand*\theenumiv{\@arabic\c@enumiv}}%
  \sloppy
  \clubpenalty4000
  \@clubpenalty \clubpenalty
  \widowpenalty4000%
  \sfcode`\.\@m
  \setlength{\itemsep}{0pt plus 0.3ex}
}
{\def\@noitemerr
	{\@latex@warning{Empty `thebibliography' environment}}%
	\endlist}

\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty

\newenvironment{theindex}{%
	\toggletrue{@restonecol}
	\twocolumn[\section*{\indexname}]%
	\@mkboth{\MakeUppercase\indexname}%
	{\MakeUppercase\indexname}%
	\thispagestyle{fancy}\parindent\z@
	\parskip\z@ \@plus .3\p@\relax
	\columnseprule \z@
	\columnsep 35\p@
	\let\item\@idxitem%
}
{
	\iftoggle{@restonecol}
		{\onecolumn}
		{\clearpage}
}

\newcommand\@idxitem{\par\hangindent 40\p@}
\newcommand\subitem{\@idxitem \hspace*{20\p@}}
\newcommand\subsubitem{\@idxitem \hspace*{30\p@}}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}

\renewcommand*\footnoterule{%
	\kern-3\p@
	\hrule\@width.4\columnwidth
	\kern2.6\p@}

\newcommand*\@makefntext[1]{%
\parindent 1em%
\noindent
\hb@xt@1.8em{\hss\@makefnmark}#1}

\newcommand*\contentsname{Contents}
\newcommand*\listfigurename{List of Figures}
\newcommand*\listtablename{List of Tables}
\newcommand*\refname{References}
\newcommand*\indexname{Index}
\newcommand*\figurename{Figure}
\newcommand*\tablename{Table}
\newcommand*\partname{Part}
\newcommand*\appendixname{Appendix}
\newcommand*\abstractname{Abstract}

\def\today{\ifcase\month\or
		January\or February\or March\or April\or May\or June\or
		July\or August\or September\or October\or November\or December\fi
	\space\number\day, \number\year}
\setlength\columnsep{20\p@}
\setlength\columnseprule{0\p@}
\setlength{\footnotesep}{\baselineskip}
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\renewcommand{\headrule}{}
\renewcommand{\footrule}{\vbox to 0pt{\hbox to\headwidth{\color{quantumgray}\leaders\hrule\hfil}\vss}}
\fancyhf{}

\pagenumbering{arabic}
\raggedbottom
\onecolumn

%title
\def\@printtitle{%
	{%		
		\edef\@titleexpanded{\detokenize\expandafter{\@title}}%
		\iftoggle{@xstring}%
			{\saveexploremode\exploregroups\StrSubstitute{\@titleexpanded}{ }{\%20}[\@titleforurl]\restoreexploremode}%
			{\gdef\@titleforurl{\@titleexpanded}}%
		\href{https://quantum-journal.org/?s=\@titleforurl\&reason=title-click}{%
				\color{quantumviolet}{%
											\@printtitletextwithappropriatefontsize\unskip%
				}%
										}%
		}%
}
% In the macro below we compute the appropriate font size of the title.
% We use \Huge if the title fits on one line and \huge if it extends over more
% than one line in font size \Huge
\def\@titleatfontsize#1{%
	#1%
	\begingroup%
	\raggedright%
	\def\selectfont{\ClassError{quantumview}{When submitting to Quantum, you are not supposed to use \string\textbf{}, \string\bf, \string\textit{} or other font formating commands inside \string\title{}. Please remove all such commands from your \string\title{}. If you really have to change the font for some part of the title you can turn off this error by giving the option allowfontchangeintitle}{}}%solution from https://tex.stackexchange.com/questions/347596/disallowing-textbf-it-sffamily-in-argument-of-macro-or-environment
	\@title%
	\endgroup%
}%

\def\@printtitletextwithappropriatefontsize{%
	\newsavebox{\@titelsaveboxHuge}%
	\savebox{\@titelsaveboxHuge}{%
		\parbox[b]{\linewidth}{%
			\@titleatfontsize{\Huge}%
		}%
	}%
	\newsavebox{\@titelsaveboxHugeoneline}%
	\savebox{\@titelsaveboxHugeoneline}{%
		\@titleatfontsize{\Huge}%
	}%
	\newsavebox{\@titelsaveboxhhuge}%
	\savebox{\@titelsaveboxhhuge}{%
		\parbox[b]{\linewidth}{%
			\@titleatfontsize{\huge}%
		}%
	}%
	\ifdimgreater{\ht\@titelsaveboxHuge}{\ht\@titelsaveboxHugeoneline}
	{\@titleatfontsize{\huge}%\usebox{\@titelsaveboxhhuge}% using huge because \the\ht\@titelsaveboxHuge{} is larger than \the\ht\@titelsaveboxHugeoneline{}
	}
	{\@titleatfontsize{\Huge}% using Huge because \the\ht\@titelsaveboxHuge{} is not larger than \the\ht\@titelsaveboxHugeoneline{}
	}
}

%renew \title to allow for and ignore an optional argument
\renewcommand{\title}[2][]{\gdef\@title{#2}}
% author handling
\newcounter{@authorcounter}
\csdef{@authors}{}
\renewcommand{\author}[2][]{%
	\ifstrempty{#1}{%
		\internal@author{#2}%
	}{%
		\internal@elseauthor{#1}{#2}
	}%
	\csdef{@authorname\the@authorcounter}{#2}%
	\def\@currentauthornumber{\the@authorcounter}%
}%
\def\addauthortolabel#1#2{%
	\ifcsdef{authorswithlabel#2}{}{\csdef{authorswithlabel#2}{}}%
	\listcsxadd{authorswithlabel#2}{#1}}%
\def\internal@elseauthor#1#2{%
	\stepcounter{@authorcounter}
	\ifcsdef{@authors}{}{\csdef{@authors}{}}%
	\listadd{\@authors}{#2}%
	\forcsvlist{\addauthortolabel{\the@authorcounter}}{#1}%
	\ifbool{@startnewauthorgroup}{\csundef{@authorgroup}}{}%
	\ifcsdef{@authorgroup}{}{\csdef{@authorgroup}{}}%
	\listxadd{\@authorgroup}{\the@authorcounter}%
	\boolfalse{@startnewauthorgroup}%
}%
\def\internal@author#1{%
	\stepcounter{@authorcounter}
	\ifcsdef{@authors}{}{\csdef{@authors}{}}%
	\listadd{\@authors}{#1}%
	\ifbool{@startnewauthorgroup}{\csundef{@authorgroup}}{}
	\ifcsdef{@authorgroup}{}{\csdef{@authorgroup}{}}%
	\listxadd{\@authorgroup}{\the@authorcounter}
	\boolfalse{@startnewauthorgroup}
}
\def\@@spaceafter#1{#1 }
\def\@@@comma{\def\@@@comma{,}}
\def\@@commaspacebefore#1{\@@@comma{}#1}
\def\@printauthor#1#2{\def\footnote{\ClassError{quantumview}{You must not put a \string\footnote{} command inside the argument of \string\author}{}}\mbox{\ifcsdef{author#1orcid}{\href{https://orcid.org/\csname author#1orcid\endcsname}{\color{black}#2}}{#2}}\ifnumcomp{\the@affiliationcounter}{>}{1}{\textsuperscript{\forlistcsloop{\@@commaspacebefore}{author#1affiliations}\unskip}}{}\ifnumcomp{#1}{<}{\the@authorcounter-1}{, }{\ifnumcomp{#1}{=}{\the@authorcounter-1}{\ifnumcomp{#1}{=}{1}{ and }{, and }}{}}}
\def\@printauthors{%
	\newcounter{@authornum}%
	\large\forlistloop{\stepcounter{@authornum}%
		\ifcsdef{author\the@authornum hasextras}{%
			\insert\footins{\footnotesize%
				%      \interlinepenalty\interfootnotelinepenalty
				%      \splittopskip\footnotesep
				%      \splitmaxdepth \dp\strutbox \floatingpenalty \@MM
				\iftoggle{@titlepage}
					{\hsize\dimexpr \linewidth\relax \@parboxrestore}%
					{\hsize\dimexpr \linewidth\relax \@parboxrestore}%
				% \flushleft%
				% \baselineskip=0pt%
				\@printauthorextrainfo{\the@authornum}\vspace{0.5\baselineskip}%
			}}{}%
		\@printauthor\the@authornum}{\@authors}%
}
\def\@@addcommabetween#1{#1, }%this adds an ugly extra comma at the end but the variant below is not expandable and therefore leads to ugly warnings: https://tex.stackexchange.com/questions/50978/macro-to-extract-typeset-plain-text-from-a-command
%\def\@@addcommabetween#1{\ifdef{\firstauthoronly}{, }{\def\firstauthoronly{\empty}}#1}
\def\@authorsonly{\forlistloop{\@@addcommabetween}{\@authors}}
% affiliation handling
\newbool{@startnewauthorgroup}
\newcounter{@affiliationcounter}
\def\@addaffiliation#1#2{
	\ifcsdef{author#2affiliations}{}{\csdef{author#2affiliations}{}}%
	\listcsgadd{author#2affiliations}{#1}
}
\newcommand{\address}[2][]{\affiliation[#1]{#2}}

%for compatibility with authblk
\newcommand{\affil}[2][]{
	\affiliation[#1]{#2}}
\newcommand{\affiliation}[2][]{%
	\ifstrempty{#1}{%
		\internal@affiliation{#2}%
	}{%
		\elseinternal@affiliation{#1}{#2}
	}}%
\def\elseinternal@affiliation#1#2{%
	\booltrue{@startnewauthorgroup}
	\ifcsdef{affiliations}{}{\csdef{affiliations}{}}%
	\expandafter\def\csname\detokenize{#2}\endcsname{#2}%
	\stepcounter{@affiliationcounter}%
	\listxadd{\affiliations}{\iftoggle{@html}{#2}{\detokenize{#2}}}%
	\csxdef{affiliation\detokenize{#2}number}{\the@affiliationcounter{}}%
	\ifcsdef{authorswithlabel#1}{%
		\forlistcsloop{\@addaffiliation{\csname affiliation\detokenize{#2}number\endcsname}}{authorswithlabel#1}%
	}{}%
}
\def\internal@affiliation#1{%
	\booltrue{@startnewauthorgroup}
	\ifcsdef{affiliations}{}{\csdef{affiliations}{}}%
	\expandafter\def\csname\detokenize{#1}\endcsname{#1} %to handle special characters such as \'a and \l we create a macro whose name is the detokenized version of #1 and that expands to #1 and later call it in \@printaffiliation
	\xifinlist{\detokenize{#1}}{\affiliations}{}{\stepcounter{@affiliationcounter}\listxadd{\affiliations}{\iftoggle{@html}{#1}{\detokenize{#1}}}\csxdef{affiliation\detokenize{#1}number}{\the@affiliationcounter{}}}%
	\forlistloop{\@addaffiliation{\csname affiliation\detokenize{#1}number\endcsname}}{\@authorgroup}%
}
\def\@printaffiliation#1#2{\ifnumcomp{\the@affiliationcounter}{>}{1}{\llap{\textsuperscript{#1}}}{}\csname #2\endcsname\ifnumcomp{#1}{<}{\the@affiliationcounter}{\newline}{}}
\def\@printaffiliations{%
	\ifcsdef{affiliations}{}{\csdef{affiliations}{}}%
	\newcounter{@affiliationnum}%
	\ifnumcomp{\the@affiliationcounter}{>}{1}{%
		\settowidth{\leftskip}{\footnotesize\textsuperscript{\the@affiliationcounter}}%
	}{}%
	{\footnotesize\color{quantumgray}%
		\forlistloop{\stepcounter{@affiliationnum}\@printaffiliation\the@affiliationnum}{\affiliations}}%
}
%collaboration and altaffiliation
\newcommand{\collaboration}[1]{\author{#1}}
\newcommand{\altaffiliation}[2][]{\affiliation{#1#2}}

% email, homepage, and thanks handling
% be careful - this section is highly sensitive to the positioning of the % marks
\def\@printauthorextrainfo#1{
	\csname @authorname#1\endcsname: 
	\ifcsdef{author#1emails}
	{%
		\forlistcsloop{\@@spaceafter}{author#1emails}%
	}
	{}%
	\ifcsdef{author#1homepages}
	{%
		\ifcsdef{author#1emails}
		{\unskip, }
		{}%
		\forlistcsloop{\@@spaceafter}{author#1homepages}%
	}
	{}%
	\ifcsdef{author#1thanks}
	{%
		\ifcsdef{author#1emails}
		{%
			\ifcsdef{author#1homepages}
			{\unskip, }
			{\unskip, }%
		}
		{%
			\ifcsdef{author#1homepages}
			{\unskip, }
			{}%
		}%
		\forlistcsloop{\@@spaceafter}{author#1thanks}%
	}
	{}%
}

\newcommand{\email}[2][]{%
	\ifcsdef{@currentauthornumber}{}{\ClassError{quantumview}{\string\email{} may only appear after the first \string\author{} command}{}}
	\@email{#1}{\href{mailto:#2}{#2}}}
\newcommand{\homepage}[2][]{%
	\ifcsdef{@currentauthornumber}{}{\ClassError{quantumview}{\string\homepage{} may only appear after the first \string\author{} command}{}}
	\@homepage{#1}{\href{#2}{#2}}}
\renewcommand{\thanks}[2][]{%
	\ifcsdef{@currentauthornumber}{}{\ClassError{quantumview}{\string\thanks{} may only appear after the first \string\author{} command}{}}
	\@thanks{#1}{#2}}
\newcommand{\orcid}[2][]{%
	\ifcsdef{@currentauthornumber}{}{\ClassError{quantumview}{\string\orcid{} may only appear after the first \string\author{} command}{}}
	\@orcid{#1}{#2}}
\def\@email#1#2{%}
	\@addemail{#1#2}{\@currentauthornumber}
	\csdef{author\@currentauthornumber hasextras}{}
}
\def\@homepage#1#2{%
	\ifcsdef{@currentauthornumber}{}{\def\@currentauthornumber{0}}%in case \homepage is called before the first author
	\@addhomepage{#1#2}{\@currentauthornumber}
	\csdef{author\@currentauthornumber hasextras}{}
}
\def\@thanks#1#2{%
	\ifcsdef{@currentauthornumber}{}{\def\@currentauthornumber{0}}%in case \thanks is called before the first author
	\@addthanks{#1#2}{\@currentauthornumber}
	\csdef{author\@currentauthornumber hasextras}{}
}
\def\@orcid#1#2{%
	\ifcsdef{@currentauthornumber}{}{\def\@currentauthornumber{0}}%in case \orcid is called before the first author
	\@addorcid{#1#2}{\@currentauthornumber}
}
\def\@addemail#1#2{
	\ifcsdef{author#2emails}{}{\csdef{author#2emails}{}}%
	\listcsgadd{author#2emails}{#1}
}
\def\@addhomepage#1#2{
	\ifcsdef{author#2homepages}{}{\csdef{author#2homepages}{}}%
	\listcsgadd{author#2homepages}{#1}
}
\def\@addthanks#1#2{
	\ifcsdef{author#2thanks}{}{\csdef{author#2thanks}{}}%
	\listcsgadd{author#2thanks}{#1}
}
\def\@addorcid#1#2{
	\csdef{author#2orcid}{#1}%
}

\newtoggle{@tikz}
\IfFileExists{tikz.sty}{\toggletrue{@tikz}}{\togglefalse{@tikz}}

\newtoggle{@xstring}
\IfFileExists{xstring.sty}{\toggletrue{@xstring}}{\togglefalse{@xstring}}

\AtBeginDocument{
	\iftoggle{@xstring}
		{\RequirePackage{xstring}}
		{}
	\iftoggle{@tikz}
	{%
		\RequirePackage{tikz}
		\usetikzlibrary{calc}
		\newlength{\@eQ}%Capital Q height
		\newlength{\@w}%line width
		\newlength{\@rl}%rounding length
		\newlength{\@cw}%character width
		\newlength{\@ch}%lower case character height
		\newlength{\@cr}%corner radius
		\newlength{\@sl}%<> slant
		\newlength{\@xt}%<> x thickeness

		\DeclareRobustCommand{\Quantum}{%
		{\sffamily%\color{quantumviolet}%
		\setlength{\@eQ}{\dimexpr\fontcharht\font`Q\relax}%
		\setlength{\@w}{0.088\@eQ}%
		\setlength{\@rl}{0.2\@eQ}%
		\setlength{\@cw}{0.5\@eQ}%
		\setlength{\@ch}{0.65\@eQ}%
		\setlength{\@cr}{0.3\@w}%
		\setlength{\@sl}{0.22\@eQ}%
		\setlength{\@xt}{1.113588507968435\@w}%=math.sqrt(1/(1-pow(22./50.,2)))*\@w
		\tikz[baseline,x=\@eQ,y=\@eQ,every node/.append style={fill=none,inner sep=0pt,outer sep=0pt,node distance=0},rounded corners=\@cr]{%
		% <> leg in back
		% \fill[] (0,0.5) -- ++(\@sl,0.5) -- ++(\@xt,0) -- ++(-\@sl,-0.5) -- ++(\@sl,-0.5) -- ++(-\@xt,0) -- cycle;
		% \fill[xshift=.95\@eQ] (0,0.5) node (eastend) {} -- ++(-\@sl,0.5) -- ++(-\@xt,0) -- ++(\@sl,-0.5) -- ++(-\@sl,-0.5) -- ++(\@xt,0) -- cycle;
		% \begin{scope}
		%   \clip[xshift=.95\@eQ,overlay] (0.5\@xt,0.5) -- ++(-\@sl,-0.5) -- (0,0) -- (0.5\@xt,0.5) ++(-2\@xt,0) -- ++(-\@sl,-0.5) -- ($(-2*\@sl,0)$) -- ++(\@sl,0.5) --cycle;
		%   \fill[xshift=.95\@eQ] (0,0) -- ++(-\@sl,0.5) -- ++(-\@xt,0) -- ++(\@sl,-0.5) -- cycle;    
		% \end{scope}
		\node[overlay,anchor=base west,opacity=0] {Q};
		% <> leg in front
		\fill[] (0,0.5) -- ++(\@sl,0.5) -- ++(\@xt,0) -- ++(-\@sl,-0.5) -- ++(\@sl,-0.5) -- ++(-\@xt,0) -- cycle;
		\begin{scope}[xshift=\@eQ]
			\fill (0,0) -- ++(-\@sl,0.5) -- ++(-\@xt,0) -- ++(\@sl,-0.5) -- cycle;
			\clip[overlay,rounded corners=0] (-1.34\@xt,0) -- ++(-\@sl,0.5) -- ++(0,-0.5) -- cycle (0.34\@xt,0) -- ++($2*(-\@sl,0.5)$) -- (0.5\@xt,1) --cycle;
			\fill (0,0.5) node (eastend) {} -- ++(-\@sl,0.5) -- ++(-\@xt,0) -- ++(\@sl,-0.5) -- ++(-\@sl,-0.5) -- ++(\@xt,0) -- cycle;
		\end{scope}
		% u
		\def\@u##1{%
		\fill[##1] (0,\@ch) -- (0,1.06\@rl) to[out=-90,in=184,looseness=1.2,overlay] ($(\@cw-\@w,0)$) -- ($(\@cw,0)$) -- ++(0,\@ch) -- ++(-\@w,0) -- ++($(0,-\@ch) + (0,\@w)$) -- ($(\@cw-\@w,\@w)$) to[out=184,in=-90,looseness=1.1] ($(\@w,1.06\@rl)$) -- (\@w,\@ch) --cycle;}
		\@u{shift={($(current bounding box.south east)+(0.172\@eQ,0)$)}}
		\node[overlay,anchor=base east,opacity=0] at (current bounding box.south east) {u};
		% a
		\fill[shift={($(current bounding box.south east)+(0.110\@eQ,0)$)}] (\@cw,0) -- ++($(0,\@ch)-(0,\@rl)$) to[out=90,in=0,looseness=1.22] ++($(-1.22\@rl,\@rl)$) -- ($(\@w,\@ch)$) -- ++(0,-\@w) -- ($(1.22\@rl,\@ch-\@w)$) to[out=0,in=90,looseness=1.3,rounded corners=0] ($(\@cw,\@ch)-(\@w,\@rl)$) -- ($(\@cw,0)-(\@w,-\@w)$) --
		($(\@rl,\@w)$) to[out=180,in=-100,looseness=0.95,rounded corners=0] ($(1.05\@w,0.33\@ch)$) to[out=80,in=176,looseness=1.0] ($(\@cw-\@w,0.47\@ch)$) to[rounded corners=0] ++(0,-\@cr) to[rounded corners=0] ++($(0,\@cr+\@w)$) to[out=176,in=0] ($(1.2\@rl,0.48\@ch)+(0,\@w)$) to[out=180,in=90,rounded corners=0] ($(0.05\@w,0.33\@ch)$) to[out=-90,in=180,looseness=1.1,rounded corners=0] ($(\@rl,0)$) -- cycle;
		\node[overlay,anchor=base east,opacity=0] at (current bounding box.south east) {a};
		% \fill[shift={($(current bounding box.south east)+(0.110\@eQ,0)$)}] (\@cw,0) -- ++($(0,\@ch)-(0,\@rl)$) to[out=90,in=0,looseness=1.22] ++($(-1.22\@rl,\@rl)$) -- ($(\@w,\@ch-0.1\@w)$) -- ++(0.1\@w,-\@w) -- ($(1.22\@rl,\@ch-\@w)$) to[out=0,in=90,looseness=1.3,rounded corners=0] ($(\@cw,\@ch)-(\@w,\@rl)$) -- ($(\@cw,0)-(\@w,-\@w)$) -- 
		% ($(\@rl,\@w)$) to[out=180,in=-100,looseness=0.95,rounded corners=0] ($(1.05\@w,0.33\@ch)$) to[out=80,in=176,looseness=1.0] ($(\@cw-\@w,0.47\@ch)$) to[rounded corners=0] ++(0,-\@cr) to[rounded corners=0] ++($(0,\@cr+\@w)$) to[out=176,in=0] ($(1.2\@rl,0.48\@ch)+(0,\@w)$) to[out=180,in=90,rounded corners=0] ($(0.05\@w,0.33\@ch)$) to[out=-90,in=180,looseness=1.1,rounded corners=0] ($(\@rl,0)$) -- cycle;
		% \node[overlay,anchor=base east,opacity=0] at (current bounding box.south east) {a};
		%n
		\fill[shift={($(current bounding box.south east)+(0.181\@eQ+\@cw,\@ch)$)},rotate=180] (0,\@ch) -- (0,\@rl) to[out=-90,in=180,looseness=1.22] ($(1.2\@rl,0)$) -- (\@cw,0) -- ++(0,\@ch) -- ++(-\@w,0) -- ++($(0,-\@ch) + (0,1.05\@w)$) to[out=182,in=-90,looseness=1.04] ($(\@w,\@rl)$) -- (\@w,\@ch) --cycle;
		\node[overlay,anchor=base east,opacity=0] at (current bounding box.south east) {n};
		% t
		\fill[shift={($(current bounding box.south east)+(0.111\@eQ,0)$)}]
		(\@w,0.9) [rounded corners=0] -- (\@w,\@ch) [rounded corners=\@cr] -- (0,\@ch) -- ++(0,-\@w) to[rounded corners=0] ++(\@w,0) -- (\@w,\@rl) to[out=-90,in=180,looseness=1.3,overlay] ($(\@w+\@rl,-0.07\@w)$) to[overlay] ++($(0.64\@cw-\@w-\@rl,0)$) -- ++(0,\@w) -- ++($(\@w+\@rl-0.64\@cw,0)$) to[out=180,in=-90,looseness=1.4] ($(2\@w,\@rl)$) -- ++($(0,\@ch-\@rl-\@w)$) -- ($(0.64\@cw,\@ch-\@w)$) -- ++(0,\@w) to[rounded corners=0] (2\@w,\@ch) -- ($(2\@w,0.9)$) --cycle;
		\node[overlay,anchor=base east,opacity=0] at (current bounding box.south east) {t};
		% u
		\@u{shift={($(current bounding box.south east)+(0.125\@eQ,0)$)}}
		% \fill[shift={($(current bounding box.south east)+(0.125\@eQ,0)$)}] (0,\@ch) -- (0,\@rl) to[out=-90,in=180] ($(\@rl,0)$) -- (\@cw,0) -- ++(0,\@ch) -- ++(-\@w,0) -- ++($(0,-\@ch) + (0,\@w)$) -- ($(\@rl,\@w)$) to[out=180,in=-90] ($(\@w,\@rl)$) -- (\@w,\@ch) --cycle;
		\node[overlay,anchor=base east,opacity=0] at (current bounding box.south east) {u};
		% m
		\fill[shift={($(current bounding box.south east)+(0.16\@eQ+1.93*\@cw-\@w,\@ch)$)},rotate=180] (0,\@ch) -- (0,\@rl) to[out=-90,in=180,looseness=1.2] ($(1.2\@rl,0)$) -- ($(1.93\@cw,0)-(\@w,0)$) -- ++(0,\@ch) -- ++(-\@w,0) -- ++($(0,-\@ch) + (0,1.05\@w)$) to[out=184,in=-4] ($(0.97\@cw,1.05\@w)+(0,0)$) -- ++($(0,-1.05\@w)+(0,\@ch)$) -- ++($(-\@w,0)$) -- ++($(0,-\@ch)+(0,1.05\@w)$) to[out=182,in=-90,looseness=1.04] ($(\@w,\@rl)$) -- (\@w,\@ch) --cycle;
		\node[overlay,anchor=base east,opacity=0] at (current bounding box.south east) {m};
		}}}
	}
	{%
		\ClassWarning{quantumview}{The tikz package could not be found and the \string\Quantum command will not produce the Quantum logo, but fall back to outputting simply the text Quantum.}
		\DeclareRobustCommand{\Quantum}{Quantum}
	}
}
%elsearticle style extra header information
\newcommand{\ead}[2][]{
	\ifstrempty{#1}{
		\email{#2}
	}{
		\iftoggle{@xstring}
			{\IfStrEq{#1}{url}{\homepage{#2}}{\email{#2}}}
			{email{#2}}
	}
}
\AtEndPreamble{
	\providecommand{\@elsearticlecommandsnotsupportederror}{\ClassError{quantumview}{The elsearticle style \string\cortext{}, \string\corref{}, \string\fntext{}, \string\fnref{}, \string\tnotetext{}, and \string\tnoteref{} commands are not supported by quantumview. Please refrain from using footnotes in the title part of your document and use the \string\tahnks{} command for author footnotes instead.}{}}
	\providecommand{\cortext}[2][]{\@elsearticlecommandsnotsupportederror} %corresponding author information
	\providecommand{\corref}[1]{\@elsearticlecommandsnotsupportederror} %corresponding author information reference
	\providecommand{\fntext}[2][]{\@elsearticlecommandsnotsupportederror} %author footnote
	\providecommand{\fnref}[1]{\@elsearticlecommandsnotsupportederror} %author footnot reference
	\providecommand{\tnotetext}[2][]{\@elsearticlecommandsnotsupportederror} %title footnote
	\providecommand{\tnoteref}[1]{\@elsearticlecommandsnotsupportederror} %title footnote reference
}

% set default options for hyperref to make links more pretty
\PassOptionsToPackage{colorlinks=true,hyperindex}{hyperref}

\PassOptionsToPackage{allcolors=quantumviolet}{hyperref}

%enable DOIs if biblatex is used by default
\PassOptionsToPackage{doi=true}{biblatex}

\AtBeginDocument{%

	\RequirePackage{hyperref}%	

	\@ifpackageloaded{natbib}{%
		\setlength{\bibsep}{0pt plus 0.3ex}
		\@ifpackageloaded{doi}{}{%
			\providecommand{\doi}[1]{}
			\renewcommand{\doi}[1]{\href{https://doi.org/\detokenize{#1}}{DOI: \detokenize{#1}}}%
		}%
	}{%
		\@ifpackageloaded{biblatex}{
			\DeclareFieldFormat{doi}{\mkbibacro{DOI}\addcolon\space\href{https://doi.org/\detokenize{#1}}{\detokenize{#1}}}
			\setcounter{biburllcpenalty}{1000}
			\setcounter{biburlucpenalty}{1000}
			\setcounter{biburlnumpenalty}{1000}
		}{}%
	}
}

\def\@keywords{}
\providecommand{\keywords}{}
\renewcommand{\keywords}[1]{\def\@keywords{#1}}

\newenvironment{acknowledgements}{\section*{Acknowledgements}}{}

\AtBeginDocument{%
	\providecommand\text[1]{
		\ClassError{quantumview}{To use the \string\text{} command please load the mathtools package}{}
	}
}

\PassOptionsToPackage{font={small,sf}}{caption}

\AtEndPreamble{
	\RequirePackage{caption}
}

\endinput
%%
%% End of file `quantumview.cls'.
