let s:match_id = -1
let s:stop_word_pat = '[^a-zA-Z_0-9$#@%]\|\n'
let s:minimum_word_len= 2

function! s:whl_word()
	call <sid>clear_whl_matches()

	let s:current_pos = getpos('.')
	let s:line = getbufline(bufnr('%'), s:current_pos[1])

	let s:word_start = searchpos( s:stop_word_pat, 'bcnp', s:current_pos[1])
	let s:word_end   = searchpos( s:stop_word_pat, 'cnp', s:current_pos[1])

	let s:word = strpart(s:line[0], s:word_start[1], s:word_end[1] - s:word_start[1] - 1)

	if strlen(s:word) >= s:minimum_word_len && s:word !~ '^\d\+$'
		highlight whighlight ctermbg=237
		let s:match_id = matchadd('whighlight', s:word.'\n\{-\}\(\([^a-zA-Z_0-9]\)\|$\)\@=')
	endif
endfunction

function! s:clear_whl_matches()
	if (s:match_id > 0)
		silent! call matchdelete(s:match_id)
		let s:match_id = -1
	endif
endfunction

augroup WordHighlight
	autocmd!
	au WinLeave * call <sid>clear_whl_matches()
	au CursorMoved <buffer> call <sid>whl_word()
augroup END
