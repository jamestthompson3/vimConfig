match Callout '@\w\+\.\?\w\+'

let b:ale_fixers = ['prettier']

iab <expr> dateheader strftime("%Y %b %d")

lua require 'tt.ft.markdown'
