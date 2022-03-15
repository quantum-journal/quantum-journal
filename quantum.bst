% This is the BibTeX style file for the Quantum journal.
% It is based on hyperabbrv.bst, and the extensions by Aram Harrow
% (see https://github.com/harrow/arxiv-bibstyle) and Andrew Comech
% (see https://www.math.tamu.edu/~comech/tools/bibtex-doi-eprint/).
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
% Variables and state descriptors
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

INTEGERS
  {
    % These are state describing integers to control
    % punctuation, capitalization, and line breaks
    output.state
    before.all
    mid.sentence
    after.sentence
    after.block

    multiresult
    doi.linked

    % Counters
    length
    namesleft
    numnames
    found.slashes
    number.label
    longest.label.width

    % Config integers
    %  - whether to print out DOI links explicitly or add the link to parts of the
    %    citation itself.
    explicit.doi.links
    %  - whether to raise compilation errors from (many) BibTeX warnings
    warnings.are.errors

    % pointers
    nameptr
    ptr
  }

STRINGS { s t m longest.label label }

FUNCTION {init.state.consts}
{ % Initialize the global state describing integeres for punctuation
  % Args:
  % Returns:
  #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Custom warning
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {my.warning}
{ % Print cited element in bibliography with error message in red.
  % If warnings.are.errors (default:True), raise a \PackageError
  % Args: str - Warning message
  % Returns:
  'm :=
  "{\color{red}{ This bibitem caused a BibTeX warning: " m * " entry.}}" *
  warnings.are.errors
    { "\PackageError{quantum.bst}{The bibitem " *
      cite$ *
      " caused a BibTeX warning}" *
      "{By default, quantum.bst handles BibTeX warnings like compilation " *
      "errors. Please refer to the bibliography style demo for details and options.}" *
    }
    'skip$
  if$
  write$
  m cite$ * warning$
}

FUNCTION {my.warning.newline}
{ % Print cited element in bibliography with error message in red.
  % If warnings.are.errors (default:True), raise a \PackageError
  % This function includes a newline in the bibliography to ensure
  % that the error message for missing links is formatted correctly.
  % Args: str - Second line of warning message
  %       str - First line of warning message
  % Returns:
  's :=
  'm :=
  "{\color{red}{ This bibitem caused a BibTeX warning: " m * "}}" *
  write$
  newline$
  "{\color{red}{" s * " entry.}}" *
  warnings.are.errors
    { "\PackageError{quantum.bst}{The bibitem " *
      cite$ *
      " caused a BibTeX warning}" *
      "{By default, quantum.bst handles BibTeX warnings like compilation " *
      "errors. Please refer to the bibliography style demo for details.}" *
    }
    'skip$
  if$
  write$
  m cite$ * warning$
}

FUNCTION {my.crossref.warning}
{ % Print cited crossref element in bibliography with error message in red.
  % If warnings.are.errors (default:True), raise a \PackageError
  % Args: str - Warning message
  % Returns:
  'm :=
  warnings.are.errors
    { "{\color{red} This bibitem caused a crossref-BibTeX warning: need "
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
{ % Logical NOT of a "Boolean"
  % Args: int - Boolean to negate
  % Returns: int - negated Boolean
    { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{ % Logical AND between two "Booleans"
  % Args: int - First Boolean to combine
  %       int - Second Boolean to combine
  % Returns: int - logical AND of input Booleans
    'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{ % Logical OR between two "Booleans"
  % Args: int - First Boolean to combine
  %       int - Second Boolean to combine
  % Returns: int - logical OR of input Booleans
    { pop$ #1 }
    'skip$
  if$
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% String manipulation
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {string.length}
{ % Count the length of a string
  % Args: str - String to count
  % Returns: int - Length of input string
  #1 'length :=
  % Increase the length by 1 until the substring of the current length is the full string
  {duplicate$ duplicate$ #1 length substring$ = not}
    {length #1 + 'length :=}
  while$
  % Pop the string and return the length
  pop$ length
}

FUNCTION {contains.substring}
{ % Check whether a substring is contained in a string
  % Args: str - Substring to find in larger string
  %       str - String to find the substring in
  % Returns: int("Boolean") - whether the substring is contained in the string
  's :=
  't :=
  % Count the length of the substring
  s string.length 'length :=
  % cut away starting characters of the string until it is empty or the substring is found
  { t empty$ not }
    % Check whether the current string starts with the substring
    { t #1 length substring$ s =
        { % If yes, empty the string and return #1
          "" 't :=
          #1
        }
        { % If not, delete the first character of the string
          t #2 global.max$ substring$ 't :=
          % If the string is empty, return #0
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
{ % Chop the beginning of a string if it matches a given second string
  % Args: str - String to chop
  %       int - Length of substring to match
  %       str - Substring to match
  % Returns: str - (Potentially) chopped string
  's :=
  'length :=
  s #1 length substring$ =
    { s length #1 + global.max$ substring$ }
    's
  if$
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Elementary output functions
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {output.nonnull}
{ % Output a string that is guaranteed not to be empty
  % Args: str - String to process
  % Returns:
  % The written output via write$ depends on the position in a sentence or block,
  % as stored in outpute.state, which is updated accordingly.
  's :=
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
{ % Output a string if it is not empty
  % Args: str - String to check and output
  % Returns:
  duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ % Check whether a string is empty, output it if it is not, and raise a my.warning if it is.
  % Args: str - Describing string of argument that is checked to provide a useful error message
  %       str - String to check and output if it is not empty
  % Returns:
  't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * my.warning }
    'output.nonnull
  if$
}

FUNCTION {no.output.check}
{ % Check whether a string is empty and raise a my.warning if it is.
  % Args: str - Describing string of argument that is checked to provide a useful error message
  %       str - String to check
  % Returns:
  't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * my.warning }
    'skip$
  if$
}

FUNCTION {no.output.check.links}
{ % Check whether a string is empty and raise a my.warning.newline if it is.
  % Args: str - Describing string of argument that is checked to provide a useful error message
  %       str - String to check
  % Returns:
  % The separate handling from no.output.check is the special warning message that contains
  % special characters, requiring us to use my.warning.newline. In addition, if the field
  % `nolink` is not missing (it may be empty though), the warning is not raised.
  't :=
  duplicate$ empty$ nolink missing$ and
    { pop$ "empty " t * ". " *
      "If none of these fields is applicable for the cited work you can include the field " *
      "\verb|`nolink = {}`| in its bib"
      my.warning.newline
    }
    'skip$
  if$
}

FUNCTION {output.bibitem}
{ % Write the current buffer and the header for a new bibitem to the bbl file and
  % updates the output.state
  % Args: str - Current buffer is written to the bbl file
  % Returns: str - An empty string
  newline$
  % Write the header for a new bibitem
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ % Finalize an entry by appending a period if appropriate and writing to the bbl file
  % Args: str - Current string to write to the bbl file
  % Returns:
  add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ % Start a new block in an entry, setting the output.state accordingly
  % Args:
  % Returns:
  output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ % Start a new sentence in an entry, setting the output.state accordingly
  % Args:
  % Returns:
  output.state after.block =
  output.state before.all =
  or
    'skip$
    { after.sentence 'output.state := }
  if$
}

FUNCTION {new.block.checka}
{ % Start a new block in an entry if the input string is not empty
  % Args: str - String to decide whether a new block is started
  % Returns:
  empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ % Start a new block in an entry if any of two input strings are not empty
  % Args: str - Second string to decide whether a new block is started
  %       str - First string to decide whether a new block is started
  % Returns:
  empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ % Start a new sentence in an entry if the input string is not empty
  % Args: str - String to decide whether a new sentence is started
  % Returns:
  empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ % Start a new sentence in an entry if any of two input strings are not empty
  % Args: str - Second string to decide whether a new sentence is started
  %       str - First string to decide whether a new sentence is started
  % Returns:
  empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ % Replace an empty field or string by the empty string ""
  % Args: str - Field or string to check and replace
  % Returns: str - The input string if it was not empty, else ""
  % This function does nothing on strings, it just replaces empty (but defined)
  % fields by the empty string in order to allow for string comparisons and other operations
  % that are not defined on empty (non-string) fields.
  duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {tie.or.space.connect}
{ % Connect two strings with a space or a non-breaking ~
  % Args: str - Second string to connect. If it is shorter than 3 characters, a ~ is used
  %       str - First string to connect.
  % Returns: str - The connected strings.
  duplicate$ text.length$ #3 <
    { % Use a ~ if the second string is shorter than 3 characters
      "~"
    }
    { % Use a space else
      " "
    }
  if$
  % Bring the strings in the order (first string, connector, second string) and merge them
  swap$ * *
}

FUNCTION {init.longest.label}
{ % Initializes globally used variables to determine the longest label in the bibliography
  % Args:
  % Returns:
  "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ % Update the longest.label.width and the longest.label, as measured by width$
  % Args:
  % Returns:
  % Note that this function does not require any input from the bilbiography items,
  % but only depends on the number of items.
  number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Entry formatting
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {boldfont}
{ % Add a bold font formatting string to a string (if it is not empty)
  % Args: str - The string to format in bold font
  % Returns: str - The input string wrapped in a formatting string for bold font
  % Only add the formatting string to a non-empty string
  duplicate$ empty$
    { pop$ "" }
    { "{\bf " swap$ * "}" * }
  if$
}

FUNCTION {format.names}
{ % Format a given string with names
  % Args: str - The string with names
  % Returns: str - The formatted names
  's :=
  % initialize pointer, counter for names and counter for names to handle left
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
  % Iterate over names
  { namesleft #0 > }
    { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
        { % After the first name, include connecting characters
          namesleft #1 >
            { % If there is more than the current name left, use a comma
              ", " * t *
            }
            { % If there is only the current name left, use "and" or "et al."
              numnames #2 >
                { % Add a comma before "and" if there were more than two names
                  "," *
                }
                'skip$
              if$
              t "others" =
                { % Replace "and others" by "et~al."
                  " et~al." *
                }
                { " and " * t * }
              if$
            }
          if$
        }
        { % Simply write the first name to buffer
          t
        }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ % Apply format.names to the author field and return it
  % Args:
  % Returns: str - author field formatted via format.names
  % If the author field is empty, the empty string is returned instead.
  author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ % Apply format.names to the editor field, add a remark "editor(s)" to it, and return it
  % Args:
  % Returns: str - editor field formatted via format.names, with ", editor(s)" appended.
  % If the editor field is empty, the empty string is returned instead.
  editor empty$
    { "" }
    {
      editor format.names
      ", editor" *
      % Add plural "s" if multiple editors are given
      editor num.names$ #1 >
        { "s" * }
        'skip$
      if$
    }
  if$
}

FUNCTION {format.title}
{ % Wrap the title in quotation marks and change its capitalization.
  % Args:
  % Returns: str - title field wrapped in quotation marks with new capitalization
  % Note that change.case$ together with the option "t" removes all capitalization
  % of text that is not in curly braces, except for the very first character.
  title empty$
    { "" }
    { "``" title "t" change.case$ * "''" *  }
  if$
}

FUNCTION { format.arxiv.hyperlink }
{ % Extract the arXiv handle from a string, removing a leading "arXiv"
  % Args: str - The string to extract the handle from
  % Returns: str - The extracted arXiv handle
  % If the string starts with "arxiv:" or "arxiv" (or any capitalized version of these),
  % the length-9 handle is extracted, otherwise the original string is returned.
  duplicate$ #1 #6 substring$ "l" change.case$ "arxiv:" =
    { #7 #9 substring$  }
    { duplicate$ #1 #5 substring$ "l" change.case$ "arxiv" =
      { #6 #9 substring$  }
      'skip$
    if$
    }
  if$
}

FUNCTION {format.eprint}
{ % Format the eprint link, including the hyperlink and the link text.
  % Args:
  % Returns: str - Hyperlink to extracted arxiv reference
  eprint empty$
    { "" }
    { archivePrefix empty$
        { primaryClass empty$
            { "arXiv" }
            { primaryClass }
          if$
        }
        { archivePrefix }
      if$
      " \href{http://arxiv.org/abs/"
      eprint format.arxiv.hyperlink *
      "}{" *
      swap$ *
      ":" *
      eprint #1 #5 substring$ "arXiv" =
        { eprint #7 #15 substring$ * }
        { eprint * }
      if$
      "}" *
    }
  if$
}

FUNCTION {add.doi.link}
{ % Add a hyperlink referring to a DOI reference to a string, using the doi field.
  % Args: str - String to add the hyperlink to
  % Returns: str - Input string with hyperlink added
  "\href{https://dx.doi.org/" doi * "}{" * swap$ * "}" *
}

FUNCTION {n.dashify}
{ % Replace single dashes by double dashes
  % Args: str - Input string to be modified
  % Returns: str - Input string with single dashes replaced by double dashes
  't :=
  ""
  % Iterate over the characters in the string
  { t empty$ not }
    { t #1 #1 substring$ "-" =
        {
          t #1 #2 substring$ "--" = not
            { % If the current `t` starts with a "-" but not with "--", replace
              % the single dash with "--" and cut the leading dash from `t`
              "--" *
              t #2 global.max$ substring$ 't :=
            }
            { % If the current `t` starts with a "--", add all dashes in the
              % current `t` to the output string without any replacement
              { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { % If the current `t` does not start with a dash, simply move the first
          % character to the output string.
          t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {format.year}
{ % Format the year of an entry
  % Args:
  % Returns: str - Formatted year in brackets
  % If the year field is empty, the year is extracted from the date field, assuming
  % that it starts with the year.
  year empty$
    { date empty$
        { "" }
        { "~(" date #1 #4 substring$ * ")" * }
      if$
    }
    { "~(" year * ")" * }
  if$
}

FUNCTION {format.urldate}
{ % Format the date on which a URL was accessed
  % Args:
  % Returns: str - The formatted date in brackets with a remark "accessed:"
  % The urldate field preceeds the date field.
  urldate empty$
    { date empty$
        { "" }
        { "(accessed:~" date * ")" * }
      if$
    }
    { "(accessed:~" urldate * ")" * }
  if$
}

FUNCTION {format.chapter}
{ % Format the chapter field for an entry
  % Args: int - "Boolean" indicating whether the "Chapter" should be turned to lower case
  % Returns: str - The formatted chapter with leading "Chapter" string.
  % If the field `type` is not empty, it is used instead of the generic "Chapter".
  type empty$
    { "Chapter" }
    { type }
  if$
  swap$
    { "l" change.case$ }
    'skip$
  if$
  chapter tie.or.space.connect
}

FUNCTION {multi.page.check}
{ % Check whether a string indicates multiple pages
  % Args: str - The string describing a page or multiple pages
  % Returns: int - "Boolean" indicating whether the string describes multiple pages
  't :=
  #0 'multiresult :=
  { multiresult not
    t empty$ not
    and
  }
    { % Check whether the first character in the current `t` is one of "-", "," or "+"
      t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { % Remove the first character from the current `t`
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ % Format the pages field of an entry
  % Args: int - "Boolean" indicating whether to capitalize the word "page(s)"
  % Returns: str - The formatted pages field, including the word "page(s)"
    { "p" }
    { "P" }
  if$
  pages multi.page.check
    { "ages" * pages n.dashify tie.or.space.connect }
    { "age" * pages tie.or.space.connect }
  if$
}

FUNCTION {format.bvol.series}
{ % Format the book volume and the series of an entry
  % Args:
  % Returns: str - The volume and series field formatted into one string.
  % Raises a warning if the field `number` is present in addition to `volume`.
  volume empty$
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
      number empty$
        'skip$
        { "can't use both volume and number fields in " * my.warning }
      if$
    }
  if$
}

FUNCTION {format.bvol.chap.pages}
{ % Format the book volume, series and the chapter and pages of an entry
  % Args:
  % Returns: str - The volume and series field formatted into one string.
  % This function wraps the previously defined functions format.bvol.series,
  % format.chapter, and format.pages into one.
  format.bvol.series
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
{ % Format the number and the series of an entry
  % Args:
  % Returns: str - The number and series field formatted into one string.
  % The returned string is empty if the `volume` field is not empty.
  % Raises a warning if the field `series` is empty.
  volume empty$
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
{ % Format the edition field of an entry
  % Args:
  % Returns: str - The edition of the entry with "edition" comment, if it
  %     is not contained in the field itself already.
  edition empty$
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

FUNCTION {format.vol.pages}
{ % Format the volume and pages for an article entry
  % Args:
  % Returns: The volume and page numbers as a single string
  volume field.or.null boldfont
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ mid.sentence output.state = format.pages }
        { " " swap$ * ", " * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ % Format the chapter and pages for an entry
  % Args:
  % Returns: str - chapter and pages description in one string
  chapter empty$
    { #0 format.pages }
    {
      mid.sentence output.state =
      format.chapter
      pages empty$
        'skip$
        { ", " *  #1 format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ % Format the booktitle together with editors of an entry
  % Args:
  % Returns: The booktitle for an entry contained in the book.
  booktitle empty$
    { "" }
    { editor empty$
        { "In " booktitle * }
        { "In " format.editors * ", " * booktitle * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ % Checks whether all relevant fields for a misc entry are empty
  % Args:
  % Returns:
  % Raises a warning if all fields are empty
  author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  % Only warn for entries that actually have a key
  key empty$ not and
    { "all relevant fields are empty in " my.warning }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ % Replace a string with the type field if given, and add a DOI link
  % Args: str - String to add the DOI link to, or to replace by the `type` field.
  % Returns: str - Input string or `type` string if present, with DOI link.
  type empty$
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
{ % Format the number of a technical report and add the remark "Technical Report"
  % or the `type` field if present.
  % Args:
  % Returns: str - `type` field or "Technical Report" together with the `number` field
  type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {get.journal}
{ % Obtain the journal from either journal, journaltitle or shortjournal,
  % in that order of priority
  % Args:
  % Returns: str - The name of the journal.
  journal missing$
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
{ % Fomat a cross-reference of an article
  % Args:
  % Returns: str - Crossref entry for an article incl. citation
  key empty$
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
{ % Fomat the editors for a cross-reference to a book, collection or proceedings
  % Args:
  % Returns: str - Editors names formatted for a cross-reference.
  editor #1 "{vv~}{ll}" format.name$
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
{ % Fomat a cross-reference to a book
  % Args:
  % Returns: str - Crossref entry to a book incl. citation
  volume empty$
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
{ % Fomat a cross-reference for an entry from a collection or proceedings
  % Args:
  % Returns: str - Crossref entry to the collection/proceedings incl. citation.
  editor empty$
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

FUNCTION {extract.repo}
{ % Obtain the repository name from the `code` field
  % Args:
  % Returns: str - The repository name to print
  % Look for registered formatting of github repos and remove them
  "github.com/" #11
    "www.github.com/" #15
      "https://github.com/" #19
        code
      chop.word
    chop.word
  chop.word
  % Extract the part of the repository name until the second slash
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
  % Return only the part up to the second slash from above
  #2 found.slashes =
    { t #1 ptr #2 - substring$ }
    { t #1 ptr substring$ }
  if$
}

FUNCTION {format.version}
{ % Format the `version` field of an entry with `code` field
  % Args:
  % Returns: str - The version with a "v" abbreviation
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
{ % Format the `commit` field of an entry with `code` field
  % Args:
  % Returns: str - The commit field with the remark "commit"
  commit empty$
    { "" }
    { " commit:" commit #1 #7 substring$ * }
  if$
}

FUNCTION {format.code}
{ % Format the `code` field
  % Args:
  % Returns: str - The `code` field with version and commit,
  %   including a link to the repository
  code empty$
    { "" }
    { " code:~\href{" code * "}{" * extract.repo * format.version * format.commit * "}" * }
  if$
}

FUNCTION {format.url}
{ % Format a url
  % Args:
  % Returns: str - The `shorturl` (preferred) or `url` field including a link
  % The "https" part is removed from the printed string of the hyperlink
  shorturl empty$
    { url empty$
        { "" }
        { " url:~\href{" url * "}{" * "https://" #8 url chop.word * "}" * }
      if$
    }
    { " url:~\href{" url * "}{" * "https://" #8 shorturl chop.word * "}" * }
  if$
}

FUNCTION {check.links}
{ % Check that one of the fields providing a hyperlink is present and raise a warning if not
  % Args:
  % Returns:
  % The fields of which one should be present are `doi`, `eprint` and
  % `url`. Setting the (empty) field `nolink={}` suppresses this warning.
  doi missing$ eprint missing$ and
    { format.url "doi, eprint and url" no.output.check.links pop$ }
    'skip$
  if$
}

FUNCTION {output.links}
{ % Output the links of an entry
  % Args:
  % Returns:
  new.block
  explicit.doi.links
    { % If explicit DOI links are set via the config, output it
      % explicitly (if it's not missing)
      doi missing$
        'skip$
        { " doi:~" doi add.doi.link * output
          new.block
        }
      if$
    }
    'skip$ % Without explicit DOI links, it has already been added to another string.
  if$
  % Add eprint link
  format.eprint output
  doi missing$ eprint missing$ and
    { % If the DOI and the eprint link are missing, add the `url` field hyperlink
      new.block
      format.url output
    }
    'skip$
  if$
  new.block
  % Add the code hyperlink
  format.code output
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Interpretation of bib entries
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {is.arxiv.article}
{ % Determine whether an article class is an arxiv article only.
  % Args:
  % Returns: int - "Boolean" indicating whether the entry is an arxiv article only
  % The article is considered an arxiv article only if
  % - get.journal delivers an empty string and the `archivePrefix` field matches "arxiv"
  %   (up to capitalization)
  % - "arxiv" (or a capitalized version of it) is present in the output of get.journal
  % If the output of get.journal is empty and the `archivePrefix` field is present but not
  % known, a warning is raised.
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
        { #1 }
        { #0 }
      if$
    }
  if$
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Raw citation classes that are aliased in the public citation classes
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {arxiv.article}
{ % Format an arxiv-only article
  output.bibitem
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
{ % Format a standard published article
  output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  crossref missing$
    { new.block
      get.journal "journal, shortjournal and journaltitle" no.output.check
      format.vol.pages *
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
{ % Format a standard misc entry
  output.bibitem
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
{ % Format the first part of a thesis entry
  output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
}

FUNCTION {thesis.end}
{ % Format the second (and last) part of a thesis entry
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

FUNCTION {conditional.doi.link}
{ duplicate$ empty$
  doi missing$
  explicit.doi.links
  doi.linked
  or or or
    'skip$
    { add.doi.link
      #1 'doi.linked :=
    }
  if$
}

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
      conditional.doi.link output
      new.block
      format.number.series
      conditional.doi.link output
      new.sentence
      publisher "publisher" no.output.check
      conditional.doi.link output
      new.sentence
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
      conditional.doi.link output
      new.block
      format.number.series
      conditional.doi.link output
      new.sentence
      publisher "publisher" no.output.check
      conditional.doi.link
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
  #0 'doi.linked :=
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      new.block
      format.bvol.chap.pages
      conditional.doi.link output
      new.block
      format.number.series
      conditional.doi.link output
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
% BIBLIOGRAPHY HEADER AND FOOTER
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

FUNCTION {begin.bib}
{ % Print the beginning of the bibliography to the .bbl file. Also set the
  % "Booleans" for the global config of DOI link printing and handling of warnings.
  #0 'explicit.doi.links :=
  #1 'warnings.are.errors :=
  preamble$ empty$
    'skip$
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
      preamble$ write$ newline$
    }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

FUNCTION {end.bib}
{ % Print the ending of the bibliography to the .bbl file.
  newline$
  "\end{thebibliography}" write$ newline$
}

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% EXECUTION
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% Initialize global constants indicating the positions in an entry
EXECUTE {init.state.consts}

% Initialize global variables for the longest label
EXECUTE {init.longest.label}

% Determine the longest label that will be needed
ITERATE {longest.label.pass}

% Begin the library and handle the preamble
EXECUTE {begin.bib}

% Create all bibliography entries
ITERATE {call.type$}

% Finalize the library
EXECUTE {end.bib}
