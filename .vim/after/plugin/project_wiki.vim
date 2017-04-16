let s:cpo_save=&cpo
set cpo&vim
"------------------------------------------------------------------------
" Commands and Mappings {{{1

command! ProjRepoCodeDir exe "new ".project_wiki#get_repo_code_dir(project_wiki#get_repo_dict())
command! ProjOrgCodeDir  exe "new ".project_wiki#get_org_code_dir(project_wiki#get_repo_dict())
command! ProjRepoWikiDir exe "new ".project_wiki#get_repo_wiki_dir(project_wiki#get_repo_dict())
command! ProjOrgWikiDir  exe "new ".project_wiki#get_org_wiki_dir(project_wiki#get_repo_dict())

command! ProjRepoWikiNote exe "new ".project_wiki#get_repo_wiki_dir(project_wiki#get_repo_dict())."/main.otl"
command! ProjOrgWikiNote  exe "new ".project_wiki#get_org_wiki_dir(project_wiki#get_repo_dict())."/main.otl"

command! ProjNbNote  exe "new ".project_wiki#get_repo_wiki_dir({ "org": "wiki", "repo": "notebook" })."/main.otl"

" Commands and Mappings }}}1
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
