<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [z-a-eval](#z-a-eval)
  - [Introduction](#introduction)
  - [Installation](#installation)
  - [How it works](#how-it-works)
  - [The Ice Modifiers Provided By The Annex](#the-ice-modifiers-provided-by-the-annex)
  - [1. **`eval'[!]{command}; …'`**](#1-evalcommand-)
- [Additional Zinit commands](#additional-zinit-commands)
- [Zinit tab completion support](#zinit-tab-completion-support)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# z-a-eval

## Introduction

A Zsh-Zinit annex (i.e. an extension) that provides functionality, which
allows to:

  1. Cache the output of arbitrarily slow initialization command to speed up shell startup time.

## Installation

Simply load like a regular plugin, i.e.:

```zsh
zinit light NICHOLAS85/z-a-eval
```

After executing this command you can then use the new ice-mods provided by
the annex.

## How it works

The output of a slow initialization command is redirected to a file located within the plugin/snippets directory and sourced while loading. The next time the plugin/snippet is loaded, this file will be sourced skipping the need to run the initialization command.

## The Ice Modifiers Provided By The Annex

There is 1 ice-modifier provided and handled by this annex. They are:
  1. `eval''` – creates a `cache` containing the output of a command.

**The ice-modifier in detail:**

---

## 1. **`eval'[!]{command}…'`**

It creates a `cache` in the plugin/snippets root directory which stores the commands output. This cache is regenerated when:
- The plugin/snippet is updated.
- The cache file is removed.
- With the new Zinit subcommand `recache`.

The optional preceding `!` flag means to store command output regardless of exit code. Otherwise `eval''` will avoid caching ouput of code which returns a non-zero exit code.

Example:

```zsh
% zinit ice wait"2" eval"dircolors -b LS_COLORS" lucid \
          atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
% zinit light trapd00r/LS_COLORS
```


# Additional Zinit commands

There's an additional Zinit command that's provided by this annex
–`recache`. It recaches all your plugins/snippets eval outputs on demand. Useful for when you change the value of the `eval''` ice but do not want to redownload the plugin/snippet to update its ices, or rm the cache manually:

![recache-invocation](https://raw.githubusercontent.com/NICHOLAS85/z-a-eval/master/images/recache.png)

Available options are:

```zsh
zinit recache [plugin/snippet]
```

When run without an argument, it will iterate through all plugin/snippets who have caches and regenerate them based on the current value of `eval''`. If `eval''` is missing, it will simply delete the cache file.

When run with a plugin/snippet argument, it will only regenerate that single plugin/snippets cache based on the current value of `eval''`.

# Zinit tab completion support
Zinit currently does not support extending the subcommands available via tab completion. I however, have implemented experimental support for this which should be duplicable across any annex.

In order to enable tab completion for the new subcommand set the value `Z_A_USECOMP=1` somewhere **before** loading this plugin. For example:
```zsh
zinit atinit'Z_A_USECOMP=1' light-mode for NICHOLAS85/z-a-eval
```

If you're interested in seeing how it works some more detail can be seen at the bottom of `z-a-eval.plugin.zsh`. I'd love to hear feedback on its implementation.
