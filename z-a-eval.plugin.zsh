# Copyright (c) 2021-2023 Nicholas Serrano
# License MIT

# According to the Zsh Plugin Standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html#zero-handling

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

autoload :za-eval-atclone-handler :za-eval-atinit-handler :za-eval-recache

# An empty stub to fill the help handler fields
:za-eval-null-handler() { :; }
:za-eval-recache-help-handler() {
    builtin print -r -- "—— ${ZINIT[col-annex]}recache${ZINIT[col-rst]} ${ZINIT[col-pname]}plg-spec${ZINIT[col-rst]}|URL          – recache plugin or snippet (or all plugins and snippets if no argument passed) which have caches based on their current ${ZINIT[col-ice]}eval''${ZINIT[col-rst]} ice value - ${ZINIT[col-u]}Registered by ${ZINIT[col-annex]}z-a-eval${ZINIT[col-rst]}${ZINIT[col-u]} annex${ZINIT[col-rst]}"
}

# Remove temporary variable
:za-eval-atload-handler() { [[ -n ${ICE[eval]} ]] && unset ZINIT_Z_A_EVAL_SOURCED; }

@zinit-register-annex "z-a-eval" \
    hook:atclone-50 \
    :za-eval-atclone-handler \
    :za-eval-null-handler \
    "eval''" # also register new ices

@zinit-register-annex "z-a-eval" \
    hook:atpull-50 \
    :za-eval-atclone-handler \
    :za-eval-null-handler

@zinit-register-annex "z-a-eval" \
    hook:atload-50 \
    :za-eval-atload-handler \
    :za-eval-null-handler

@zinit-register-annex "z-a-eval" \
    hook:atinit-50 \
    :za-eval-atinit-handler \
    :za-eval-null-handler

@zinit-register-annex "z-a-eval" \
    subcommand:recache \
    :za-eval-recache \
    :za-eval-recache-help-handler

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
