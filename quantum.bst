% This is the BibTeX style file for the Quantum journal.
% It is based on hyperabbrv.bst (see ), and the extensions by Aram Harrow (see )
% and Andrew Comech (see https://www.math.tamu.edu/~comech/tools/bibtex-doi-eprint/).
%
% In addition to added arxiv and DOI hyperlinks, the file style incorporates design
% choices made for Quantum journal, in particular in the light of online availability.
% Furthermore, this file style introduces some custom reference classes as well as
% custom entry fields.

ENTRY
  { address
    archivePrefix
    author
    booktitle
    chapter
    code
    commit
    date
    doi
    edition
    editor
    eprint
    howpublished
    institution
    journal
    journaltitle
    key
    month
    note
    nolink
    number
    organization
    pages
    primaryClass
    publisher
    school
    series
    shortjournal
    shorturl
    title
    type
    url
    urldate
    version
    volume
    year
  }
  {}
  {}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% State descriptors
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

INTEGERS
  { output.state
    before.all
    mid.sentence
    after.sentence
    after.block
    len
    explicit.doi.links
    warnings.are.errors
  }

FUNCTION {init.state.consts}
{
  #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Custom warning
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

STRINGS { m }

FUNCTION {my.warning}
{ 'm :=
  warnings.are.errors
    { "{\color{red}{ This bibitem caused a BibTeX warning: "
      m * " entry.}}\PackageError{quantum.bst}{The bibitem " *
      cite$ *
      " caused a BibTeX warning}" *
      "{By default, quantum.bst handles BibTeX warnings like compilation " *
      "errors. Please refer to the bibliography style demo for details.}" *
      write$
    }
    'skip$
  if$
  m cite$ * warning$
}

FUNCTION {my.crossref.warning}
{ 'm :=
  warnings.are.errors
    { "\ReferToPDFOutput" write$
      newline$
      "{\color{red} This bibitem caused a crossref-BibTeX warning: need "
      m * " to crossref.}\PackageError{quantum.bst}{The crossref bibitem " *
      cite$ *
      " caused a BibTeX warning}" *
      "{By default, quantum.bst handles BibTeX warnings like compilation " *
      "errors. Please refer to the bibliography style demo for details.}" *
      write$
    }
    'skip$
  if$
  "need " m * " for " * cite$ * " to crossref " * crossref * warning$
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Boolean functions
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% String manipulation
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

STRINGS { s t }

FUNCTION {string.length}
{
  #1 'len :=
  {duplicate$ duplicate$ #1 len substring$ = not}
    {len #1 + 'len :=}
  while$
  pop$ len
}

FUNCTION {contains.substring}
{ 's :=
  't :=
  s string.length 'len :=
    { t empty$ not }
    { t #1 len substring$ s =
        { "" 't :=
          #1
        }
        { t #2 global.max$ substring$ 't :=
          t empty$
            { #0 }
            'skip$
          if$
        }
      if$
    }
  while$
}

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Elementary output functions
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    'write$
    { output.state after.block =
        { add.period$ write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { add.period$ " " * write$ }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * my.warning }
    'output.nonnull
  if$
}

FUNCTION {no.output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * my.warning }
    'skip$
  if$
}

FUNCTION {no.output.check.links}
{ 't :=
  duplicate$ empty$ nolink missing$ and
    { pop$ "empty " t * ". " *
      "If none of these fields is applicable for the cited work you can include the field " *
      "\newline\verb|`nolink = {}`| in its bib" *
      my.warning
    }
    'skip$
  if$
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * my.warning }
  if$
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Entry formatting
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

FUNCTION {boldfont}
{ duplicate$ empty$
    { pop$ "" }
    { "{\bf " swap$ * "}" * }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { numnames #2 >
                { "," * }
                'skip$
              if$
              t "others" =
                { " et~al." * }
                { " and " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
        { ", editors" * }
        { ", editor" * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { "``" title "t" change.case$ * "''" *  }
  if$
}

FUNCTION { format.longeprint }
{ duplicate$ #1 #5 substring$ "arXiv" =
     { #7 #15 substring$  }
     { "" * }
  if$
}

FUNCTION { format.arxiv.hyperlink }
{ duplicate$ #1 #6 substring$ "arXiv:" =
    { #7 #9 substring$  }
    { duplicate$ #1 #5 substring$ "arXiv" =
      { #6 #9 substring$  }
      { "" * }
    if$
    }
  if$
}

FUNCTION {format.eprint}
{ eprint empty$
    { "" }
    {
      primaryClass empty$
        { " \href{http://arxiv.org/abs/" eprint format.arxiv.hyperlink * "}" *
          "{arXiv:" * eprint format.longeprint * "}" *
        }
	    { archivePrefix empty$
            { " \href{http://arxiv.org/abs/" eprint format.arxiv.hyperlink * "}" *
	          "{arXiv:" * eprint format.longeprint * "}" *
            }
            { " \href{http://arxiv.org/abs/" eprint format.arxiv.hyperlink * "}" *
	          "{" * archivePrefix * ":" * eprint format.longeprint * "}" *
            }
          if$
        }
      if$
    }
  if$
}

FUNCTION {add.doi.link}
{ "\href{https://dx.doi.org/" doi * "}{" * swap$ * "}" * }

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.year}
{ year empty$
    { date empty$
        { "" }
        { "~(" date #1 #4 substring$ * ")" * }
      if$
    }
    { "~(" year * ")" * }
  if$
}

FUNCTION {format.urldate}
{ urldate empty$
    { date empty$
        { "" }
        { "(accessed:~" date * ")" * }
      if$
    }
    { "(accessed:~" urldate * ")" * }
  if$
}

FUNCTION {format.chapter}
{ type empty$
    { "Chapter" }
    { type }
  if$
  swap$
    { "l" change.case$ }
    'skip$
  if$
  chapter tie.or.space.connect
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{   { "p" }
    { "P" }
  if$
  pages multi.page.check
    { "ages" * pages n.dashify tie.or.space.connect }
    { "age" * pages tie.or.space.connect }
  if$
}

FUNCTION {format.bvol.series}
{ volume empty$
    { "" }
    { mid.sentence output.state =
        { "v" }
        { "V" }
      if$
      "olume" * volume tie.or.space.connect
      series empty$
        'skip$
        { " of " * series * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.bvol.chap.pages}
{ format.bvol.series
  chapter empty$
    'skip$
    { duplicate$ empty$
        { #0 }
        { ", " *
          #1
        }
      if$
      format.chapter *
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { #0 }
        { ", " *
          #1
        }
      if$
      format.pages *
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { output.state mid.sentence =
            { "number" }
            { "Number" }
          if$
          number tie.or.space.connect
          series empty$
            { "there's a number but no series in " my.warning }
            { " in " * series * }
          if$
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {format.edition}
{ edition empty$
  { "" }
  { output.state mid.sentence =
    { edition "l" change.case$ }
    { edition "t" change.case$ }
    if$
    edition "edition" contains.substring
      'skip$
      { " edition" * }
    if$
  }
  if$
}

FUNCTION {format.vol.num.pages}
{ " " volume field.or.null boldfont *
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ mid.sentence output.state = format.pages }
        { ", " * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    { #0 format.pages }
    {
      type empty$
        { "Chapter" }
        { type }
      if$
      mid.sentence output.state =
        { "l" change.case$ }
        'skip$
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " *  #1 format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { "In " booktitle * }
        { "In " format.editors * ", " * booktitle * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " my.warning }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
  doi missing$
  explicit.doi.links
  or
    'skip$
    { add.doi.link }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {get.journal}
{ journal missing$
    {
    journaltitle missing$
      {
      shortjournal missing$
        { "" }
        { shortjournal }
      if$
      }
      { journaltitle }
    if$
    }
    { journal }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { get.journal empty$
        { "key or journal" my.crossref.warning
          ""
        }
        { "In {\em " get.journal * "\/}" * }
      if$
    }
    { "In " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv~}{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { pop$ " et~al." * }
    { #2 <
        'skip$
        { editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " et~al." * }
            { " and " * editor #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "volume" my.crossref.warning
      "In "
    }
    { "Volume" volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { series empty$
            { "editor, key, or series" my.crossref.warning
              "" *
            }
            { "{\em " * series * "\/}" * }
          if$
        }
        { key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
        { booktitle empty$
            { "editor, key, or booktitle" my.crossref.warning
              ""
            }
            { "In {\em " booktitle * "\/}" * }
          if$
        }
        { "In " key * }
      if$
    }
    { "In " format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

INTEGERS { ptr found.slashes }

FUNCTION {extract.repo}
{
  "github.com/" #11
    "www.github.com/" #15
      "https://github.com/" #19
        code
      chop.word
    chop.word
  chop.word
  't :=
  #0 'found.slashes :=
  #1 'ptr :=
  { ptr t text.length$ < #2 found.slashes > and}
    {t ptr #1 substring$ "/" =
      { found.slashes #1 + 'found.slashes := }
      'skip$
    if$
    ptr #1 + 'ptr := }
  while$
  #2 found.slashes =
    { t #1 ptr #2 - substring$ }
    { t #1 ptr substring$ }
  if$
}

FUNCTION {format.version}
{
  version empty$
    { "" }
    {
      "v" version #1 #1 substring$ =
        { " " version * }
        { " v" version * }
      if$
    }
  if$
}

FUNCTION {format.commit}
{
  commit empty$
    { "" }
    { " commit:" commit #1 #7 substring$ * }
  if$
}

FUNCTION {format.code}
{ code empty$
    { "" }
    { " code:~\href{" code * "}{" * extract.repo * format.version * format.commit * "}" * }
  if$
}

FUNCTION {format.url}
{ shorturl empty$
    { url empty$
        { "" }
        { " url:~\href{" url * "}{" * "https://" #8 url chop.word * "}" * }
      if$
    }
    { " url:~\href{" url * "}{" * "https://" #8 shorturl chop.word * "}" * }
  if$
}

FUNCTION {check.links}
{ doi missing$ eprint missing$ and
    { format.url "doi, eprint and url" no.output.check.links pop$ }
    'skip$
  if$
}

FUNCTION {output.links}
{
  new.block
  explicit.doi.links
    { doi missing$
        'skip$
        { " doi:~" doi add.doi.link * output
          new.block
        }
      if$
    }
    'skip$
  if$
  format.eprint output
  doi missing$ eprint missing$ and
    { new.block
      format.url output
    }
    'skip$
  if$
  new.block
  format.code output
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Interpretation of bib entries
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {is.arxiv.article}
{
  get.journal empty$
    { archivePrefix missing$
        { #0 }
        { archivePrefix "l" change.case$ "arxiv" =
          { #1 }
          { "The `archivePrefix' " archivePrefix * " is not supported for entry" * my.warning
            #0
          }
        if$
        }
      if$
    }
    { get.journal "l" change.case$ "arxiv" contains.substring
      get.journal "arXiv" contains.substring
      or
        { #1 }
        { #0 }
      if$
    }
  if$
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Raw citation classes that are aliased in the public citation classis
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {arxiv.article}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  crossref missing$
    {
      format.year "year" output.check
      new.block
      check.links
      output.links
    }
    { format.article.crossref output.nonnull
      #1 format.pages output
    }
  if$
  fin.entry
}

FUNCTION {std.article}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  crossref missing$
    { new.block
      get.journal "journal, shortjournal and journaltitle" no.output.check
      format.vol.num.pages *
      doi missing$
      explicit.doi.links
      or
        'skip$
        { add.doi.link }
      if$
      output
      format.year "year" output.check
      new.block
      check.links
      output.links
    }
    { format.article.crossref output.nonnull
      #1 format.pages output
    }
  if$
  fin.entry
}

FUNCTION {std.misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.year output
  format.eprint output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {thesis.start}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
}

FUNCTION {thesis.end}
{
  new.block
  school "school" output.check
  new.block
  address output
  format.year "year" output.check
  new.block
  output.links
  fin.entry
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Recognized citation classes
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {article}
{ is.arxiv.article
  'arxiv.article
  'std.article
  if$
}

INTEGERS { doi.linked }

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull }
  if$
  new.block
  format.title "title" output.check
  new.block
  #0 'doi.linked :=
  crossref missing$
    { format.bvol.chap.pages
      duplicate$ empty$
      doi missing$
      explicit.doi.links
      or or
        'skip$
        { add.doi.link
          #1 'doi.linked :=
        }
      if$
      output
      new.block
      format.number.series
      duplicate$ empty$
      doi missing$
      explicit.doi.links
      doi.linked
      or or or
        'skip$
        { add.doi.link
          #1 'doi.linked :=
        }
      if$
      output
      new.sentence
      publisher "publisher" no.output.check
      doi missing$
      explicit.doi.links
      doi.linked
      or or
        'skip$
        { add.doi.link
          #1 'doi.linked :=
        }
      if$
      output
      address output
    }
    { format.chapter.pages output
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.year "year" output.check
  new.block
  format.edition output
  check.links
  output.links
  fin.entry
}

FUNCTION {repository}
{ output.bibitem
  format.authors output
  format.year output
  new.block
  code empty$
    { format.url "url" output.check }
    { format.code output }
  if$
  fin.entry
}

FUNCTION {website}
{ output.bibitem
  author empty$
    'skip$
    { format.authors output.nonnull }
  if$
  new.block
  format.title "title" output.check
  new.block
  format.url "url" output.check
  new.block
  code empty$
    'skip$
    { format.code output
      new.block
    }
  if$
  format.urldate output
  note output
  fin.entry
}

FUNCTION {misc}
{ is.arxiv.article
    'arxiv.article
    'std.misc
  if$
}

FUNCTION {inbook}
{
  format.chapter.pages empty$
    { "`inbook' requires chapter or pages, otherwise use `book'" my.warning }
    'skip$
  if$
  book
}

FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.title "title" no.output.check
  doi missing$
  explicit.doi.links
  or
    'skip$
    { add.doi.link }
  if$
  output
  new.block
  format.bvol.series output
  format.number.series output
  new.block
  address empty$
    { editor empty$
        { publisher new.sentence.checka }
        { organization publisher new.sentence.checkb
          organization output
        }
      if$
      new.block
      publisher output
      format.year "year" output.check
    }
    { address output.nonnull
      format.year "year" output.check
      new.sentence
      editor empty$
        'skip$
        { organization output }
      if$
      new.block
      publisher output
    }
  if$
  new.block
  check.links
  output.links
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  howpublished new.block.checka
  howpublished output
  address new.block.checka
  address output
  format.year output
  output.links
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  note "note" output.check
  format.year output
  format.eprint output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  #0 'doi.linked :=
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      new.block
      format.bvol.chap.pages
      duplicate$ empty$
      doi missing$
      explicit.doi.links
      or or
        'skip$
        { add.doi.link
          #1 'doi.linked :=
        }
      if$
      output
      new.block
      format.number.series
      duplicate$ empty$
      doi missing$
      explicit.doi.links
      doi.linked
      or or or
        'skip$
        { add.doi.link
          #1 'doi.linked :=
        }
      if$
      output
      new.sentence
      publisher "publisher" no.output.check
      doi missing$
      explicit.doi.links
      doi.linked
      or or
        'skip$
        { add.doi.link
          #1 'doi.linked :=
        }
      if$
      address missing$
        'skip$
        { ", " * address * }
      if$
      output
      format.year "year" output.check
      new.block
      format.edition output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  new.block
  output.links
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      new.block
      format.bvol.chap.pages
      duplicate$ empty$
      doi missing$
      explicit.doi.links
      or or
        'skip$
        { add.doi.link
          #1 'doi.linked :=
        }
      if$
      output
      new.block
      format.number.series
      duplicate$ empty$
      doi missing$
      explicit.doi.links
      doi.linked
      or or or
        'skip$
        { add.doi.link
          #1 'doi.linked :=
        }
      if$
      output
      address empty$
        { organization publisher new.sentence.checkb
          organization output
          publisher output
          format.year "year" output.check
        }
        { address output.nonnull
          format.year "year" output.check
          new.sentence
          organization output
          new.sentence
          publisher output
        }
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  check.links
  output.links
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.tr.number
  doi missing$
  explicit.doi.links
  or
    'skip$
    { add.doi.link }
  if$
  output.nonnull
  new.block
  institution "institution" output.check
  address output
  format.year "year" output.check
  output.links
  fin.entry
}

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
        'skip$
        { organization output.nonnull
          new.block
          address output
        }
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.title "title" output.check
  author empty$
    { organization empty$
        { address new.block.checka
          address output
        }
        'skip$
      if$
    }
    { organization address new.block.checkb
      organization output
      new.block
      address output
    }
  if$
  new.block
  format.edition output
  format.year output
  output.links
  fin.entry
}

FUNCTION {mastersthesis}
{ thesis.start
  "Master's thesis" format.thesis.type output.nonnull
  thesis.end
}

FUNCTION {phdthesis}
{ thesis.start
  "PhD thesis" format.thesis.type output.nonnull
  thesis.end
}


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Default citation type
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {default.type} { article }

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Macros/aliases
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

MACRO {jan} {"Jan."}

MACRO {feb} {"Feb."}

MACRO {mar} {"Mar."}

MACRO {apr} {"Apr."}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"Aug."}

MACRO {sep} {"Sept."}

MACRO {oct} {"Oct."}

MACRO {nov} {"Nov."}

MACRO {dec} {"Dec."}

MACRO {acmcs} {"ACM Comput. Surv."}

MACRO {acta} {"Acta Inf."}

MACRO {cacm} {"Commun. ACM"}

MACRO {ibmjrd} {"IBM J. Res. Dev."}

MACRO {ibmsj} {"IBM Syst.~J."}

MACRO {ieeese} {"IEEE Trans. Softw. Eng."}

MACRO {ieeetc} {"IEEE Trans. Comput."}

MACRO {ieeetcad}
 {"IEEE Trans. Comput.-Aided Design Integrated Circuits"}

MACRO {ipl} {"Inf. Process. Lett."}

MACRO {jacm} {"J.~ACM"}

MACRO {jcss} {"J.~Comput. Syst. Sci."}

MACRO {scp} {"Sci. Comput. Programming"}

MACRO {sicomp} {"SIAM J. Comput."}

MACRO {tocs} {"ACM Trans. Comput. Syst."}

MACRO {tods} {"ACM Trans. Database Syst."}

MACRO {tog} {"ACM Trans. Gr."}

MACRO {toms} {"ACM Trans. Math. Softw."}

MACRO {toois} {"ACM Trans. Office Inf. Syst."}

MACRO {toplas} {"ACM Trans. Prog. Lang. Syst."}

MACRO {tcs} {"Theoretical Comput. Sci."}

READ

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% SORTING
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
        { "   " * }
        'skip$
      if$
      s nameptr "{vv{ } }{ll{ }}{  f{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
        { "et al" * }
        { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
        { "to sort, need author or key in " my.warning
          ""
        }
        { key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
        { key empty$
            { "to sort, need author, editor, or key in " my.warning
              ""
            }
            { key sortify }
          if$
        }
        { editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
        { key empty$
            { "to sort, need author, organization, or key in " my.warning
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
        { key empty$
            { "to sort, need editor, organization, or key in " my.warning
              ""
            }
            { key sortify }
          if$
        }
        { "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
        'editor.organization.sort
        { type$ "manual" =
            'author.organization.sort
            'author.sort
          if$
        }
      if$
    }
  if$
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% OUTPUT GENERATION
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

STRINGS { longest.label label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    { #0 'explicit.doi.links :=
      #1 'warnings.are.errors :=
    }
    { preamble$ "MakeDoiLinksExplicit" contains.substring
        { #1 'explicit.doi.links :=
          "\newcommand{\MakeDoiLinksExplicit}{}" write$ newline$
        }
        { #0 'explicit.doi.links := }
      if$
      preamble$ "DoNotMakeWarningsErrors" contains.substring
        { #0 'warnings.are.errors :=
          "\newcommand{\DoNotMakeWarningsErrors}{}" write$ newline$
        }
        { #1 'warnings.are.errors := }
      if$
      preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}
