" Skip CI builds
" - Appveyor: <https://www.appveyor.com/docs/how-to/filtering-commits/#skip-directive-in-commit-message>
"       - [ci skip], [skip ci], [skip appveyor]
" - Travis CI: <https://docs.travis-ci.com/user/customizing-the-build/#Skipping-a-build>
"       - [ci skip], [skip ci]
syntax match gitcommitCIDirective "\[\(ci skip\|skip ci\|skip appveyor\)\]"
syntax match gitcommitCIDirectiveFirst "\[\(ci skip\|skip ci\|skip appveyor\)\]" contained containedin=gitcommitSummary

highlight link gitcommitCIDirective Special
highlight link gitcommitCIDirectiveFirst Special
