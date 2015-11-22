#!/bin/sh
# text files
find . -name '*.[hc]pp' -o -name '*.[hc]' \
    -o -name '*.xhtml' -o -name '*.html' -o -name '*.htm' -o -name '*.css' \
    -o -name '*.docs' -o -name '*.doxy' -o -name '*.qbk' \
    -o -name '*.el' -o -name '*.cmake' -o -name '*.vb' \
    -o -name '*.ipp' -o -name '*.jam' -o -name '*.tpp' \
    -o -iname '*.txt' -o -name '*.tex' -o -name '*.dtd' \
    -o -name '*.xml' -o -name 'stub.*' -o -name '*.rst' \
    -o -name '*.i' -o -name '*.py' -o -name '*.rb' -o -name '*.R' \
    -o -iname '*.pl' -o -name '*.scm' -o -name '*.ss' \
    -o -name '*.cs' -o -name '*.java' -o -name '*.nsi' \
    -o -name '*.nsh' \
    -o -name '*.tpp' -o -name '*.Makefile' -o -name '*.README' \
    -o -name '*.mak' -o -name 'Makefile' -o -name '*.rules' \
    -o -name '*.target' -o -name '*.configure' -o -name '*.nmake' \
 | xargs -n 1 svn propset svn:eol-style native
# these should have UNIX eol, even when extracted from a .zip
find . -name '*.a[cm]' -o -name '*.m4' -o -name '*.in' \
    -o -name '*.sh' -o -name '*.1' \
 | xargs -n 1 svn propset svn:eol-style LF
# these should have Windows eol, even when extracted from a .tar.gz
find . -name '*.dev' -o -name '*.sln' \
    -o -name '*.vcproj' -o -name '*.csproj' \
    -o -name '*.vcxproj' -o -name '*.vbproj' \
    -o -name '*.cmd' -o -name '*.bat' \
    -o -name '*.dsw' -o -name '*.dsp' \
 | xargs -n 1 svn propset svn:eol-style CRLF
# these should have svn:needs-lock
find . -name '*.ico' \
    -o -name '*.xls' -o -name '*.xla' -o -name '*.xll' \
    -o -name '*.doc' -o -name '*.pdf' \
 | xargs -n 1 svn propset svn:needs-lock 1
# these should have svn:mime-type application/msword
find . -name '*.doc' \
 | xargs -n 1 svn propset svn:mime-type application/msword
# these should have svn:mime-type application/vnd.ms-excel
find . -name '*.xla' -o -name '*.xll' -o -name '*.xls' \
 | xargs -n 1 svn propset svn:mime-type application/vnd.ms-excel
# these should have svn:mime-type application/pdf
find . -name '*.pdf' \
 | xargs -n 1 svn propset svn:mime-type application/pdf
# these should have svn:executable
find . -name '*.sh' \
 | xargs -n 1 svn propset svn:executable 1
# these should have svn:mime-type image/gif
find . -name '*.gif' \
 | xargs -n 1 svn propset svn:mime-type image/gif
# these should have svn:mime-type image/x-icon
find . -name '*.ico' \
 | xargs -n 1 svn propset svn:mime-type image/x-icon
# these should have svn:mime-type image/jpeg
find . -name '*.jpg' \
 | xargs -n 1 svn propset svn:mime-type image/jpeg
# these should have svn:mime-type image/png
find . -name '*.png' \
 | xargs -n 1 svn propset svn:mime-type image/png
find . -name '*.cpp' -o -name '*.h' -o -name '*.inl' \
 | xargs -n 1 svn propset svn:keywords Id
