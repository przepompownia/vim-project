if exists('g:loaded_project')
  finish
endif

let g:loaded_project = 1

let g:projectInitialCwd = getcwd()

""
" The list of files that determine workspace root directory
" if contained within
let g:projectRootPatterns = get(g:, 'projectRootPatterns', [])

""
" The list of directories that should not be considered as workspace root directory when resolve project root by root pattern
" (in addition to '/' which is always considered)
let g:projectGlobalRootPatterns = get(g:, 'projectGlobalRootPatterns', ['/', '/home'])
""
" The list of enabled methods used to resolve the project root.
" The order matters: if a given method succeeded, the rest are ignored.
" Valid are 'initialCwd', 'rootMarkers', 'manual'. Invalid entries will be ignored.
" 'initialCwd' always returns with a success and will be always appended to this list as a fallback.
" There is no need to add 'initialCwd' explicitely because any method present after it will be ignored.
" Since the resolver can be run from autocommand, you can have to `set shortmess -=F`
" to prevent disable user prompt needed to use 'manual'.
let g:projectNoninteractiveResolvers = get(g:, 'projectNoninteractiveResolvers', ['rootMarkers'])

""
" Once a php buffer has been open prompt user how to resolve its project root.
" Note that  you can have to `set shortmess -=F`
" otherwise it probably will not work.
let g:projectAllowInteractiveProjectResolution = get(g:, 'projectAllowInteractiveProjectResolution', v:false)

let g:projectAssigner = get(g:, 'projectAssigner', project#assigner#create(
            \ project#repository#create(),
            \ g:projectRootPatterns,
            \ g:projectGlobalRootPatterns,
            \ g:projectInitialCwd,
            \ g:projectNoninteractiveResolvers
            \ ))

augroup project
    autocmd!
    autocmd FileType php call project#assigner#assignProjectToBuffer(expand('<afile>'), v:false, g:projectAllowInteractiveProjectResolution)
augroup END

" vim: et ts=4 sw=4 fdm=marker
