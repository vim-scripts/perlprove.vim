" Vim Compiler File
" Compiler:     runs perl's Test::Unit 'prove'
" Maintainer:   harm@tty.nl
" OriginalMaintainer:   Christian J. Robinson <infynity@onewest.net>
" Creation and Last Change:  2005 Jul 28
"
" Installation:
" - Copy this file to ~/.vim/compiler/
" - Add to yor .vimrc: 
"   au BufRead,BufNewFile *.t set filetype=perl | compiler perlprove

if exists("current_compiler")
  finish
endif
let current_compiler = "perlprove"

if exists(":CompilerSet") != 2		" older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

let s:savecpo = &cpo
set cpo&vim

" Usage: :make - prove the current testfile
"        :make t - run prove and give arguments to prove ('t' in this case)
" The perl after the pipe is a poormans-unbuffered-grep
CompilerSet makeprg=prove\ -v\ \`if\ test\ -n\ \"$*\"\;\ then\ echo\ \"$*\"\;\ else\ echo\ \"%\"\;\ fi\`\ 2>/dev/stdout\ 1>/dev/null\\\|cat
" |perl\ -ne\'BEGIN\{\$\\\|\+\+\}\;\ print\ if\ not\ /\^ok\/\' 

CompilerSet errorformat=
	\%m\ at\ %f\ line\ %l.,
    \%I#\ Looks\ like\ you\ %m%.%#,
    \%Z\ %#,
    \%E#\ \ \ \ \ Failed\ test\ (%f\ at\ line\ %l),
    \%C#\ \ \ \ \ %m,
    \%Z#\ %#%m,
    \#\ %#Failed\ test\ (%f\ at\ line\ %l),
	\%-G%.%#had\ compilation\ errors.,
	\%-G%.%#syntax\ OK,
	\%+A%.%#\ at\ %f\ line\ %l\\,%.%#,
	\%+Z%.%#
" informational, number of failures
" Failed test, has 2 info lines
" Failed test, single line, no info
" Perl syntax errors. Copied from the vim perl compiler package

" Explanation:
" %-G%.%#had\ compilation\ errors.,  - Ignore the obvious.
" %-G%.%#syntax\ OK,                 - Don't include the 'a-okay' message.
" %m\ at\ %f\ line\ %l.,             - Most errors...
" %+A%.%#\ at\ %f\ line\ %l\\,%.%#,  - As above, including ', near ...'
" %+C%.%#                            -   ... Which can be multi-line.

let &cpo = s:savecpo
unlet s:savecpo
