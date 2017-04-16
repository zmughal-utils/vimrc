let s:cpo_save=&cpo
set cpo&vim

function! project_wiki#get_repo_wiki_dict()
	let l:matches = matchlist(expand("%:p:h"), 'sw_projects/wiki/notebook/notebook/project/\([^/]\+\)\(/repo/\([^/]\+\)\)\?')
	let l:repo_dict = { "org": l:matches[1], "repo": l:matches[3] }
	return l:repo_dict
endfunction

function! project_wiki#get_repo_code_dict()
	let l:matches = matchlist(expand("%:p:h"), 'sw_projects/\([^/]\+\)\(/\([^/]\+\)/\3\)\?')
	let l:repo_dict = { "org": l:matches[1], "repo": l:matches[3] }
	return l:repo_dict
endfunction

function! project_wiki#get_repo_dict()
	let l:code_repo = project_wiki#get_repo_code_dict()
	if( l:code_repo.org == "wiki" && l:code_repo.repo == "notebook" )
		return project_wiki#get_repo_wiki_dict()
	else
		return l:code_repo
	endif
endfunction

function! project_wiki#get_repo_code_dir(repo_dict)
	return printf("~/sw_projects/%s/%s/%s",
				\  a:repo_dict.org,
				\ a:repo_dict.repo,
				\ a:repo_dict.repo)
endfunction

function! project_wiki#get_org_code_dir(repo_dict)
	return printf("~/sw_projects/%s",
				\  a:repo_dict.org )
endfunction

function! project_wiki#get_repo_wiki_dir(repo_dict)
	return printf("~/sw_projects/wiki/notebook/notebook/project/%s/repo/%s",
				\ a:repo_dict.org,
				\ a:repo_dict.repo)
endfunction

function! project_wiki#get_org_wiki_dir(repo_dict)
	return printf("~/sw_projects/wiki/notebook/notebook/project/%s",
				\ a:repo_dict.org)
endfunction

let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
