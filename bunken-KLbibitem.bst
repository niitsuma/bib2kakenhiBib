% bunkenhtml-URL.bst
	%   by Tatsunori Mori <mori@forest.eis.ynu.ac.jp>
	%   Last modified: "2003/09/04 19:08:42 (JST)"
	%
	% Following is the original copyright notice of jplain.bst
	% ----------------------------------------------------------------
	% $Id: bunkenhtml.bst,v 1.2 2002/02/05 10:11:48 k-abe Exp $
	% This file, bunkenhtml.bst, is derived from jplain.bst.
	% Please notify all bugs to Kota Abe <k-abe@media.osaka-cu.ac.jp>
	% 
	% Following is the original copyright notice of jplain.bst
	% ----------------------------------------------------------------

	% version 0.30 for JBibTeX versions 0.30 or later, LaTeX version 2.09.
	% Copyright (C) 1990, all rights reserved.
	%
	% This file is derived from btxbst.doc of BibTeX 0.99c
	%
	% Copying of this file is authorized only if either
	% (1) you make absolutely no changes to your copy, including name, or
	% (2) if you do make changes, you name it something other than
	% jbtxbst.doc, jplain.bst, junsrt.bst, jalpha.bst, jabbrv.bst,
	% tipsj.bst, jipsj.bst, tieice.bst, jname.bst, jorsj.bst
	%
	% This restriction helps ensure that all standard styles are identical.
	% The file jbtxbst.doc has the documentation for this style.
	%
	% Please notify Shouichi MATSUI(matsui@denken.or.jp) of any bugs in
	% these standard styles or in this documentation file.
	% 松井 正一  (財) 電力中央研究所　情報システム部

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    %jtitle
    type
    volume
    year
    yomi
    xtype
    reviewed
    %buntan
    url
    ps
    pdf
  }
  {is.kanji.entry}

  { label }


INTEGERS { output.state before.all mid.sentence after.sentence after.block }

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
FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=

}
STRINGS { s t }


FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =

    %{ ", " * write$ }
    { " " * write$ }

    { output.state after.block =
	{ 

          %add.period$ write$
          write$


	  newline$
	}

	{ output.state before.all =
	    'write$

	    { 
	      %add.period$ " " * write$ 
	      " " * write$ 
	    }

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
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}
FUNCTION {output.bibitem}
{ newline$

  % "<li><p>" write$ newline$
  % "<li>"  write$  newline$ "<bibtexkey>" write$ cite$ write$  "</bibtexkey>" write$
   "& \KLbibitem "  write$  newline$    "\label{pub:" write$ cite$ write$  "} " write$
  %"<li id=" write$  cite$ write$  ">" write$ 

 % newline$
  % ""
  before.all 'output.state :=
}

FUNCTION {format.url}
{
  ""
  url empty$
    {}
    {"<a href=" * quote$ * url * quote$ * ">[link]</a>" * }
  if$
  ps empty$
    {}
    {"<a href=" * quote$ * ps * quote$ * ">[ps]</a>" * }
  if$
  pdf empty$
    {}
    {"<a href=" * quote$ * pdf * quote$ * ">[pdf]</a>" * }
  if$
}

FUNCTION {fin.entry}
{ 
 add.period$
 write$ newline$
 %"</p></li>" write$ newline$
 " \\ " write$ newline$
}

% FUNCTION {fin.entry}
% { 
%   %add.period$
%   write$ newline$
%   % format.url
%   duplicate$ empty$
%     { pop$ }
%     { 
%       %"<br />" 
%       " "
%       write$ write$}
%   if$
%   %"</p></li>" 
%   %"</li>" 
%   write$ newline$
% }

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


FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { duplicate$ is.kanji.str$
	'skip$
	%{ "<i>" swap$ * "</i>" * }
	'skip$
      if$
    }
  if$
}

INTEGERS { nameptr namesleft numnames }
FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }

    { s nameptr "{ff}{ll}" format.name$ is.kanji.str$
	{s nameptr "{ff}{ll}" format.name$ 't :=}
 	%{s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=}
	{s nameptr "{ff }{vv }{ll}{, jj}" format.name$ 't :=}
      if$

      nameptr #1 >
	{ namesleft #1 >

	    {", " * t * }


	    { t "others" =

 		{ s is.kanji.str$

 			{"ほか" * }


 			{", et~al." * }

 		  if$
 		}
 		{ s is.kanji.str$

 		    {", " * t * }



		    { numnames #2 =
 			{" and " * t * }
 			{", and " * t * }
		      if$
		    }


 		   if$
 		}
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
    %{author format.names}
    {
      %"<num.names>" author num.names$ int.to.str$  * "</num.names>"
      %"<auther>" *  author format.names "</auther>" * *
      " , " *  author format.names " " * *
    }
  if$
}
FUNCTION {format.editors}
{ editor empty$
    { "" }

    { editor format.names

      editor num.names$ #1 >
 	{ editor is.kanji.str$

 		{"（編）" * } {", editors" * } if$

 	}
 	{ editor is.kanji.str$

 		{"（編）" *} {", editor" * } if$

 	}
      if$
    }
  if$
}


INTEGERS { tindex }
STRINGS { tchar tpp remain latexstr }
FUNCTION {unlatex}
{
  'latexstr :=
  #1 'tindex :=
  "" 'tpp :=
  { latexstr tindex #1000 substring$ 'remain := 
    remain "" = not }
    {
      % fetch the first character
      remain #1 #1 substring$ 'tchar :=
      tchar is.kanji.str$
        { remain #1 #2 substring$ 'tchar := 
	  tindex #2 + 'tindex := }
	{ tindex #1 + 'tindex := }
      if$

      tchar "&" =
        { "&amp;" 'tchar := }
        'skip$
      if$

      tchar "{" =
      tchar "}" =
      tchar "\" =
      or
      or
        'skip$
	{ tpp tchar * 'tpp := }
      if$
        
%      tindex int.to.str$ write$ tchar write$
%      tchar is.kanji.str$ int.to.str$ write$ newline$
    }
  while$
  tpp
}

FUNCTION {format.title}
{
 title empty$
    { "" }
    % { "`<b>" title unlatex "</b>'" * * }
    % { "<b>" title unlatex "</b>" * * }
    % { "<title>" title unlatex "</title>" * * }
    {  " ,  ''"   title unlatex "''  " * * }
    %{  " " title unlatex  " " * * }
  if$
}

% FUNCTION {format.jtitle}
% {
%  jtitle empty$
%     { "" }
%     { "<jtitle>" jtitle unlatex "</jtitle>" * * }
%   if$
% }

% FUNCTION {format.buntan}
% {
%  buntan empty$
%     { "" }
%     { "<buntan>" buntan unlatex "</buntan>" * * }
%   if$
% }

FUNCTION {format.reviewed}
{
  reviewed empty$    
    { "  ,  査読なし "  }   
      {  reviewed  "yes"   =	
	  { " , 査読あり "  } 
	  { " , 査読なし " }
	if$	
      }
  if$
}




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

FUNCTION {format.date.month.to.number}
{ month empty$ { "" }
    { month "January" = { "1" }
    { month "February" = { "2" }
    { month "March" = { "3" }
    { month "April" = { "4" }
    { month "May" = { "5" }
    { month "June" = { "6" }
    { month "July" = { "7" }
    { month "August" = { "8" }
    { month "September" = { "9" }
    { month "October" = { "10" }
    { month "November" = { "11" }
    { month "December" = { "12" }
    'month
      if$ } if$ } if$ } if$ } if$ } if$ }
      if$ } if$ } if$ } if$ } if$ } if$ }
  if$
}

FUNCTION {format.date}

{ 
year empty$
%     { month empty$
 	{ "" }
% 	{ "there's a month but no year in " cite$ * warning$
% %	  month
%          is.kanji.entry
%            { format.date.month.to.number "月" * }
%            'month
%          if$
% 	}
%       if$
%     }
    { "(" year ")" * * }

% %%   { month empty$
% %%       { "(" year ")" * * }
% %%	{ "(" year "-" month ")" * * * * }
% %%     if$
% %%   }
% %-       { month " " * year * }

%        % { is.kanji.entry
%        %     { year "年" * format.date.month.to.number "月" * * }
%        %     { month " " * year * }
%        %   if$
%        % }
       
%     { year "年" * format.date.month.to.number "月" * * }


  if$
}

FUNCTION {format.btitle}

{ title emphasize
}

FUNCTION {tie.or.space.connect}
{
 " " swap$ * *
% duplicate$ text.length$ #3 <
%    { "~" }
%    { " " }
%  if$
%  swap$ * *
}
FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}
FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { volume is.kanji.str$
	{ volume }
	{ is.kanji.entry
	    {"第" volume * "巻" *}
	    {"Vol." volume tie.or.space.connect}
	  if$
	}
      if$
      series empty$
	'skip$
	{ series is.kanji.str$
	    { volume empty$
		{series swap$ * }

		{series ", " * swap$ * }

	      if$
	    }
	    { " of " * series emphasize * }
	  if$
	}
      if$
      "volume and number" number either.or.check
    }
  if$
}
FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ number is.kanji.str$ 
	    { number }
	    {"No." number tie.or.space.connect}
	  if$
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { series is.kanji.str$

	        { series ", " * swap$ * }

	        { " in " * series * }
	      if$
	    }
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
    { edition is.kanji.str$
	{ edition }
        { is.kanji.entry
	    {"第" edition * "版" *}
	    { output.state mid.sentence =
	      { edition "l" change.case$ " edition" * }
	      { edition "t" change.case$ " edition" * }
              if$
	    }
	  if$
        }
      if$
    }
  if$
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
{ pages empty$
    { "" }
    { pages multi.page.check

 	{ "pp." pages n.dashify tie.or.space.connect }
	{ "p." pages tie.or.space.connect }

      if$
    }
  if$
}


FUNCTION {format.vol.num.pages}
{ volume empty$
     {""}


     { volume is.kanji.str$
        {volume  ", " * }
        {"Vol." volume tie.or.space.connect ", " * }
       if$
     }


  if$
  number empty$
    'skip$

    { number is.kanji.str$
        {number *}
        {"No." number tie.or.space.connect *}
      if$

      volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
	{ number empty$

 	    { format.pages * }
 	    { ", " * format.pages * }

	  if$
	}
      if$
    }
  if$
}


FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ chapter is.kanji.str$
	    { "" }
	    { is.kanji.entry
		{"章"}
		{"chapter"}
	      if$
	    }
	  if$
	}
	{ type "l" change.case$ }
      if$
      chapter is.kanji.str$ not is.kanji.entry and
          {"第" chapter * swap$ *}
          { chapter is.kanji.str$
		{chapter *}
		{chapter tie.or.space.connect}
	    if$
	  }
      if$
      pages empty$
	'skip$

	{ ", " * format.pages * }

      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
 	% { booktitle is.kanji.str$
 	%     { " " booktitle unlatex emphasize * }
 	%     { "In " booktitle unlatex emphasize * }
 	%   if$
 	% }
 	{ booktitle }
 	% { booktitle is.kanji.str$
 	%     { " " format.editors * ", " * booktitle unlatex * }
 	%     { "In " format.editors * ", " * booktitle unlatex emphasize * }
 	%   if$
 	% }
 	{ " " format.editors *  " , " * booktitle unlatex * }
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and

  key empty$ not and

    { "all relevant fields are empty in " cite$ * warning$ }
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

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
 	% { title is.kanji.str$
 	%     { " " journal *  }  	   
  	%     { "In <i>" journal * "</i>" * }
        %   if$
	% }
	%{ "<journal>" journal * "</journal>" * }
        { " " journal * " " * }
      if$
    }
    % { title is.kanji.str$
    % 	{ " " key * }
    % 	{ "In " key * }
    %   if$
    % }
	% { "<journal>" key * "</journal>" * }
	{ " , " key * " " * }
  if$
  " \cite{" * crossref * "}" *
}
FUNCTION {format.crossref.editor}
{ editor is.kanji.str$

     {editor #1 "{ff}" format.name$ duplicate$

      empty$
 	{pop$ editor #1 "{ll}" format.name$}
 	'skip$
      if$
      }

      {editor #1 "{vv~}{ll}" format.name$}

  if$
  editor num.names$ duplicate$
  #2 >
    { editor is.kanji.str$

	  {pop$ "ほか" *} {pop$ ", et~al." * } if$

    }
    { #2 <
	'skip$

	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =

 	    { editor is.kanji.str$

 		{"ほか" *} {", et~al." * } if$

 	    }
 	    { editor is.kanji.str$
 		{

		  ", " *

 		   editor #2 "{ff}" format.name$ duplicate$
 		   empty$
 			{pop$ editor #2 "{ll}" format.name$}
 			'skip$
 		   if$
 		 *
 		}
 		{" and " * editor #2 "{vv~}{ll}" format.name$ * }
 	      if$
 	    }
	  if$
	}
      if$
    }
  if$
}
FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
       title is.kanji.str$

 	{"  "} {"In "} if$

    }
    { volume is.kanji.str$
	{ volume }
	{ is.kanji.entry
	    {"第" volume * "巻" *}
	    {"Vol." volume tie.or.space.connect " of " *  }
	  if$
	}
      if$
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }

	    { series is.kanji.str$

		{ series ", " * swap$ * }

	        %{ "<i>" * series * "</i>" * }
	        { " " * series * " " * }
	      if$
	    }

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
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
 	    % { booktitle is.kanji.str$
 	    % 	{ booktitle }
 	    %     {"In <i>" booktitle * "</i>" * }
 	    %    if$
 	    % } 
	    % {"<booktitle>" booktitle * "</booktitle>" * } 
	    {" " booktitle * " " * } 
	  if$
	}
	 %{ "In " key * }
	 %  {"<booktitle>" key * "</booktitle>" * } 
	    { " , " key * " " * } 
      if$
    }
    % { title is.kanji.str$
    % 	{" " format.crossref.editor * }
    % 	{"In " format.crossref.editor * }
    %   if$
    % }
    % {"<booktitle>" format.crossref.editor  *  "</booktitle>" * } 
    {" , " format.crossref.editor  *  " " * } 
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {article}
{ output.bibitem
  new.block
  format.title "title" output.check
  new.block

  format.authors "author" output.check
  new.block

  % format.jtitle "jtitle" output.check
  % new.block

  % format.buntan "buntan" output.check
  % new.block

  crossref missing$
    { 
        % journal emphasize "journal" 
	% "<journal>" journal * "</journal>" *  "journal"
       " , " journal * " " *  "journal"
	output.check
	new.block

	format.reviewed "reviewed" output.check
	new.block


      % format.vol.num.pages output
      % "<volume>" format.vol.num.pages * "</volume>"  * output
      " , " format.vol.num.pages * "  "  * output
      %format.vol.num.pages output


      % format.date "year" 
      % "<year>" format.date * "</year>"  * "year"  
      " , " format.date * " "  * "year"  
      % format.date "year" 
      output.check

    } 
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$

  %new.block

  note output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output
      new.block
      format.number.series output

      new.sentence

      publisher "publisher" output.check
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output

  format.date "year" output.check

  new.block
  note output
  fin.entry
}
FUNCTION {booklet}
{ output.bibitem
  format.authors output
  new.block
  format.title "title" output.check
  howpublished address new.block.checkb
  howpublished output
  address output
  format.date output

  new.block
  note output
  fin.entry
}
FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
	{ "author and editor" editor either.or.check }
	'skip$
      if$
    }
  if$
  new.block
  format.btitle "title" output.check
  crossref missing$
    { format.bvolume output

      format.chapter.pages "chapter and pages" output.check

      new.block
      format.number.series output

      new.sentence

      publisher "publisher" output.check
      address output
    }

    { format.chapter.pages "chapter and pages" output.check

      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date "year" output.check


  new.block
  note output
  fin.entry
}
FUNCTION {incollection}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output


      format.chapter.pages output



      new.sentence

      publisher "publisher" output.check
      address output
      format.edition output

      format.date "year" output.check

    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$

  new.block
  note output
  fin.entry
}
FUNCTION {inproceedings}
{ output.bibitem
  
  format.title "title" output.check
  new.block

  format.authors "author" output.check

  %new.block

  crossref missing$
    {
 
      %format.in.ed.booktitle  
      %"<booktitle>" format.in.ed.booktitle *  "</booktitle>" *
      " , " format.in.ed.booktitle *  " " *
      "booktitle"       output.check
    
      

      format.reviewed "reviewed" output.check
      new.block



      %format.bvolume 
      % "<volume>" format.bvolume * "</volume>"  *      
      " , " format.bvolume * " "  *      
      % ", " format.bvolume       
      output

      %format.number.series 
      %"<series>" format.number.series  * "</series>" *
      " ,  " format.number.series  * " " *
      %format.number.series
      output 

      %format.pages 
      % "<pages>" format.pages  * "</pages>"
      " , " format.pages  * " "
      %format.pages 
      output

      address empty$
	{ organization publisher new.sentence.checkb

	  organization output

	  %publisher output
	  % "<publisher>" publisher * "</publisher>"  * output
	  publisher output
	  
	  %format.date 
	   % "<year>" format.date * "</year>"  * 
	   format.date 
	  "year" output.check

	}
	{ 
	  %address 
	  %"<address>" address * "</address>" *
	  address 
	  output.nonnull

	  %format.date 
	  %"<year>" format.date * "</year>"  * 
	  format.date 
	  "year" output.check


	  % new.sentence

	  % organization output

	  %publisher output
	  %"<publisher>" publisher * "</publisher>"  * output
	  %publisher output



	}
      if$
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$

  new.block
  note output
  fin.entry
}
FUNCTION {conference} { inproceedings }
FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
	'skip$
	{ organization output.nonnull
	  address output
	}
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
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
      address output
    }
  if$
  format.edition output
  format.date output

  new.block
  note output
  fin.entry
}
FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check

  new.block
  note output
  fin.entry
}
FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  format.date output

  new.block
  note output
  fin.entry
  empty.misc.check
}
FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  "PhD thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check

  new.block
  note output
  fin.entry
}
FUNCTION {proceedings}
{ output.bibitem
  editor empty$
    { organization output }
    { format.editors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
	{ publisher new.sentence.checka }
	{ organization publisher new.sentence.checkb
	  organization output
	}
      if$
      publisher output
      format.date "year" output.check

    }
    { address output.nonnull
      format.date "year" output.check


      new.sentence

      editor empty$
	'skip$
	{ organization output }
      if$
      publisher output
    }
  if$
  new.block
  note output
  fin.entry
}



FUNCTION {techreport}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  format.date "year" output.check

  new.block
  note output
  fin.entry
}


% FUNCTION {techreport}
% { output.bibitem
%   new.block
%   format.title "title" output.check
%   new.block

%   format.authors "author" output.check
%   new.block

%   crossref missing$
%     { 
%         % journal emphasize "journal" 
% 	% "<journal>" journal * "</journal>" *  "journal"
%        " , " journal * " " *  "journal"
% 	output.check
% 	new.block

% 	format.reviewed "reviewed" output.check
% 	new.block


%       % format.vol.num.pages output
%       % "<volume>" format.vol.num.pages * "</volume>"  * output
%       " , " format.vol.num.pages * "  "  * output
%       %format.vol.num.pages output


%       % format.date "year" 
%       % "<year>" format.date * "</year>"  * "year"  
%       " , " format.date * " "  * "year"  
%       % format.date "year" 
%       output.check

%     } 
%     { format.article.crossref output.nonnull
%       format.pages output
%     }
%   if$

%   %new.block

%   note output
%   fin.entry
% }






FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.title "title" output.check
  new.block
  note "note" output.check
  format.date output
  fin.entry
}
FUNCTION {default.type} { misc }

%MACRO {jan} {"January"}
%MACRO {feb} {"February"}
%MACRO {mar} {"March"}
%MACRO {apr} {"April"}
%MACRO {may} {"May"}
%MACRO {jun} {"June"}
%MACRO {jul} {"July"}
%MACRO {aug} {"August"}
%MACRO {sep} {"September"}
%MACRO {oct} {"October"}
%MACRO {nov} {"November"}
%MACRO {dec} {"December"}

MACRO {jan} {"1"}
MACRO {feb} {"2"}
MACRO {mar} {"3"}
MACRO {apr} {"4"}
MACRO {may} {"5"}
MACRO {jun} {"6"}
MACRO {jul} {"7"}
MACRO {aug} {"8"}
MACRO {sep} {"9"}
MACRO {oct} {"10"}
MACRO {nov} {"11"}
MACRO {dec} {"12"}


MACRO {acmcs} {"ACM Computing Surveys"}
MACRO {acta} {"Acta Informatica"}
MACRO {cacm} {"Communications of the ACM"}
MACRO {ibmjrd} {"IBM Journal of Research and Development"}
MACRO {ibmsj} {"IBM Systems Journal"}
MACRO {ieeese} {"IEEE Transactions on Software Engineering"}
MACRO {ieeetc} {"IEEE Transactions on Computers"}
MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}
MACRO {ipl} {"Information Processing Letters"}
MACRO {jacm} {"Journal of the ACM"}
MACRO {jcss} {"Journal of Computer and System Sciences"}
MACRO {scp} {"Science of Computer Programming"}
MACRO {sicomp} {"SIAM Journal on Computing"}
MACRO {tocs} {"ACM Transactions on Computer Systems"}
MACRO {tods} {"ACM Transactions on Database Systems"}
MACRO {tog} {"ACM Transactions on Graphics"}
MACRO {toms} {"ACM Transactions on Mathematical Software"}
MACRO {toois} {"ACM Transactions on Office Information Systems"}
MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}
MACRO {tcs} {"Theoretical Computer Science"}
MACRO {tieice} {"電子情報通信学会論文誌"}
MACRO {tipsj}  {"情報処理学会論文誌"}
MACRO {jipsj}  {"Journal of Informatin Processing Society of Japan"}
MACRO {jorsj}  {"Journal of the Operations Research Society of Japan"}

READ
FUNCTION {set.is.kanji.entry}
{
  author    field.or.null is.kanji.str$
  title     field.or.null is.kanji.str$ or
  editor    field.or.null is.kanji.str$ or
  journal   field.or.null is.kanji.str$ or
  booktitle field.or.null is.kanji.str$ or
  series    field.or.null is.kanji.str$ or
  'is.kanji.entry :=
}
ITERATE {set.is.kanji.entry}

FUNCTION {sortify}
{ purify$
  "l" change.case$
}
INTEGERS { len }
FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}



FUNCTION {sort.format.names}
{ 's :=
  yomi empty$
     'skip$
     { yomi 's := }
  if$
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
	{ ", " * }
	'skip$
      if$

      s nameptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=

      nameptr numnames = t "others" = and
 	{ s is.kanji.str$

 		{"ほか" * }

 		{"et~al." *}
	  if$
 	}
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
	{ "to sort, need author or key in " cite$ * warning$
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
	    { "to sort, need author, editor, or key in " cite$ * warning$
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
	    { "to sort, need author, organization, or key in " cite$ * warning$
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
	    { "to sort, need editor, organization, or key in " cite$ * warning$
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

  %
  % sort by "year + month"
  %
  xtype "査読付き学術論文" =
    { "90" }
    { xtype "査読付き会議論文" =
      { "80" }
      { xtype "その他の論文" =
        { "70" }
        { xtype "解説その他" =
          { "60" }
          { xtype "著書" =
            { "50" }
	    { xtype "学位論文" =
              { "40" }
              { "Unknown xtype!" warning$ "00" }
	     if$
            }
           if$
          }
        if$
        }
      if$
      }
    if$
    }
  if$

  year field.or.null
  *
  "   "
  *
  month empty$
    { "00" }
%   { "00" month * #-1 #2 substring$ }
    { "00" month * duplicate$
      #-1 #2 substring$ duplicate$ "月" =
	{pop$ #-3 #2 substring$}
	{swap$ pop$}
      if$
    }
  if$
  *
  'sort.key$ :=
}
ITERATE {presort}
SORT


STRINGS { longest.label }
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
%EXECUTE {initialize.longest.label}
%ITERATE {longest.label.pass}

STRINGS { prevxtype }
FUNCTION {begin.bib}
{
  "" 'prevxtype :=
}

FUNCTION {section}
{
  % "_SECTION(" swap$ * ")" * write$ newline$
}

FUNCTION {iterator}
{
   % year prevyear = not
   % {
   %     % prevyear "" = not
   %     % {
   %     %   year  write$ newline$ 
   %     % }
   %     %'skip$
   %     if$
   %     %xtype section
   %     %"<ol>" write$ newline$
   % 	 year  write$ newline$ 
   % 	 year  'prevyear :=
   % }
   % 'skip$
   % if$

   call.type$

   year  'prevyear :=

}

EXECUTE {begin.bib}
EXECUTE {init.state.consts}
REVERSE {iterator}
FUNCTION {end.bib}
{
  %"</ol>" write$ newline$
}
EXECUTE {end.bib}
