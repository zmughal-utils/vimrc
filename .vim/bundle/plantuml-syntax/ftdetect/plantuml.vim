" Vim ftdetect file
" Language:     PlantUML
" Maintainer:   Aaron C. Meadows < language name at shadowguarddev dot com>
" Version:      0.1

if did_filetype()
  finish
endif

autocmd BufRead,BufNewFile * :if getline(1) =~ '^.*startuml.*$'| setfiletype plantuml | set filetype=plantuml | endif
autocmd BufRead,BufNewFile *.pu,*.uml,*.plantuml setfiletype plantuml | set filetype=plantuml
