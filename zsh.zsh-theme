## Variables ##
# %m -- machine name
# %n -- username
# %c -- base path
# %~ -- full path
# %D -- date
# %T -- time
# %I -- running tasks
# %M -- hostname

# Import seperate config files
for r in $HOME/.zsh/*.zsh; do
  if [[ $DEBUG > 0 ]]; then
    echo "zsh: sourcing $r"
  fi
  source $r
done

# Auto Complete And Auto Load
autoload -U colors && colors
autoload -U compinit && compinit
autoload -U promptinit && promptinit
autoload -U vcs_info && vcs_info
compinit
promptinit
#export LS_COLORS 
export LANG=en_US.UTF-8

# Dircolors
#eval $( dircolors -b $HOME/.zsh/LS_COLORS )

case $HOST in
    MBP.local)
        hostcolor=green
    ;;
    archserver)
        hostcolor=yellow
        ;;
    arch)
        hostcolor=white
        ;;
    archwebsrv)
        hostcolor=magneta
        ;;
    *)
        hostcolor=gray
        ;;
esac

PROMPT='%{$fg[blue]%}>%{$fg[yellow]%}>%{$fg[green]%}>%{$reset_color%}  '
RPROMPT='[%{$fg[$hostcolor]%}%m%{$reset_color%}]%{$fg[blue]%}$(git_prompt_info)$(svn_prompt_info)%{$reset_color%}[%{$fg[blue]%}%~%{$reset_color%}]'


#Git prompt styling
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}[%{$fg[blue]%}git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ⚡%{$fg[blue]%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""

#Git status styling
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} A"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} M"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} D"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} R"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} N"



#/===========\#
#  Functions  #
#\===========/#

function svn_prompt_info {
    # Set up defaults
    local svn_branch=""
    local svn_repository=""
    local svn_version=""
    local svn_change=""

    # only if we are in a directory that contains a .svn entry
    if [ -d ".svn" ]; then
        # query svn info and parse the results
        svn_branch=`svn info | grep '^URL:' | egrep -o '((tags|branches)/[^/]+|trunk).*' | sed -E -e 's/^(branches|tags)\///g'`
        svn_repository=`svn info | grep '^Repository Root:' | egrep -o '(http|https|file|svn|svn+ssh)/[^/]+' | egrep -o '[^/]+$'`
        svn_version=`svnversion -n`
        
        # this is the slowest test of the bunch
        change_count=`svn status | grep "?\|\!\|M\|A" | wc -l`
        if [ "$change_count" != "       0" ]; then
            svn_change="%{$fg[red]%} ⚡%{$reset_color%}"
        else
            svn_change=""
        fi
        
        # show the results
        echo "%{$reset_color%}[%{$fg[blue]%}svn: $svn_version%{$reset_color%}%{$fg[yellow]%}$svn_change%{$reset_color%}]"
        
    fi
}
