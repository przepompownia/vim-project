function! project#fileutils#searchUpwardBySingleMarker(path, marker) abort
  let l:markerFile = findfile(a:marker, fnamemodify(a:path, ':p:h').';')

  return empty(l:markerFile) ? v:null : fnamemodify(l:markerFile, ':p:h')
endfunction

function! project#fileutils#searchDirectoryUpwardByRootMarkers(initialDirectory, workspaceRootMarkers, forbiddenDirs)
  for l:marker in a:workspaceRootMarkers
    let l:markerPath = project#fileutils#searchUpwardBySingleMarker(a:initialDirectory, l:marker)

    if v:null is l:markerPath
      continue
    endif

    if empty(a:forbiddenDirs) || ! project#fileutils#containsDirectoryFrom(l:markerPath, a:forbiddenDirs)
      return l:markerPath
    endif
  endfor

  return v:null
endfunction

function! project#fileutils#normalizePath(path) abort
  let l:modifiers = isdirectory(a:path) ? ':p:h' : ':p'

  return simplify(fnamemodify(a:path, l:modifiers))
endfunction

function! project#fileutils#containsDirectoryFrom(directory, dirList) abort
  let l:directory = project#fileutils#normalizePath(a:directory)

  for l:subdir in a:dirList
    let l:subdir = project#fileutils#normalizePath(l:subdir)
    if project#fileutils#isSubdir(l:subdir, l:directory)
      return v:true
    endif
  endfor

  return v:false
endfunction

function! project#fileutils#isSubdir(expectedSubdir, directory) abort
  let l:expectedSubdir = project#fileutils#normalizePath(a:expectedSubdir)
  let l:directory = project#fileutils#normalizePath(a:directory)

  return stridx(l:expectedSubdir, l:directory) == 0
endfunction
