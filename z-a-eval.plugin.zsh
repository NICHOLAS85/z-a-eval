# Copyright (c) 2021 Nicholas Serrano
# License MIT

# According to the Zsh Plugin Standard:
# http://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

autoload :za-ev-atclone-handler :za-ev-atinit-handler :za-ev-recache

# An empty stub to fill the help handler fields
:za-ev-null-handler() { :; }

# Remove temporary variable
:za-ev-atload-handler() { [[ -n ${ICE[eval]} ]] && unset ZINIT_Z_A_EVAL_SOURCED; }

@zinit-register-annex "z-a-eval" \
    hook:atclone-50 \
    :za-ev-atclone-handler \
    :za-ev-null-handler \
    "eval''" # also register new ices

@zinit-register-annex "z-a-eval" \
    hook:atpull-50 \
    :za-ev-atclone-handler \
    :za-ev-null-handler

@zinit-register-annex "z-a-eval" \
    hook:atload-50 \
    :za-ev-atload-handler \
    :za-ev-null-handler

@zinit-register-annex "z-a-eval" \
    hook:atinit-50 \
    :za-ev-atinit-handler \
    :za-ev-null-handler

@zinit-register-annex "z-a-eval" \
    subcommand:recache \
    :za-ev-recache \
    :za-ev-null-handler

(( Z_A_USECOMP )) || return;

# Annex provides a completion file with the prefix _zinit
# Annex provies the 'shim' below which will run all available zinit completions
# Lastly the shim is assigned as zinits completion with a compdef call
autoload -Uz _zinit_recache
_zinit_shim(){
  unset -f $funcstack[1]
  eval "
    $funcstack[1](){
      ${(F)${(@ok)functions[(I)_zinit*]/%/ \"\$@\"}//$funcstack[1] \"\$@\"}
    }
    eval $funcstack[1] \$@
  "
}
compdef _zinit_shim zinit
