# ~/.profile
# assume bash compatible shell
# this file must get sourced by a shell specific profile (ZSH: .zprofile, bash: .bash_profile)
#  you may link this to .xprofile as well
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-${HOME}/.config}
if [[ -d "${HOME}/tmp" ]]; then
	XDG_CACHE_HOME="${HOME}/tmp/.cache"
else
	XDG_CACHE_HOME=${XDG_CACHE_HOME:-${HOME}/.cache}
fi
export XDG_CACHE_HOME #="${HOME}/.cache"
export XDG_DATA_HOME=${XDG_DATA_HOME:-${HOME}/.local/share}

# define additional PATH folders here
pathar=("${XDG_DATA_HOME}/../bin")

# default applications by env
# emacs > nvim > vim > vi
EDITOR=vi
if type emacsclient >/dev/null 2>&1; then
    EDITOR='emacsclient -qcn --alternate-editor=emacs'
elif type nvim >/dev/null 2>&1; then
    EDITOR=nvim
	# solarized8_flat or OceanicNext
    export NVIM_THEME=solarized8_flat
elif type vim >/dev/null 2>&1; then
    EDITOR=vim
fi
export EDITOR
export SUDO_EDITOR=vi
export ALTERNATE_EDITOR=vi
export VISUAL=$EDITOR
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'
export LESSHISTFILE="${XDG_CACHE_HOME}/lesshist"

# debug
if [[ -e "${XDG_CONFIG_HOME}/profile/_debug" ]]; then
	echo "$(date +%s): .profile" >> "${HOME}/shell_debug.log"
fi

MACHINE=${HOST:-$HOSTNAME}
MACHINE=$(printf "%s" $MACHINE | tr '[:upper:]' '[:lower:]')
# https://stackoverflow.com/a/13864829
if [[ ! -z ${MACHINE+x} ]]; then
	if [[ -r "${HOME}/.profile-${MACHINE}" ]]; then
		source "${HOME}/.profile-${MACHINE}"
	elif [[ -r "${XDG_CONFIG_HOME}/profile/profile-${MACHINE}" ]]; then
		source "${XDG_CONFIG_HOME}/profile/profile-${MACHINE}"
	fi
fi

# as late as possible
if type realpath >/dev/null 2>&1; then
	for (( i=0; i < ${#pathar[@]}; i++ )); do
		pathar[$i]="$(realpath -qs "${pathar[$i]}")"
	done
	unset i
fi
if [[ -n "$ZSH_VERSION" ]]; then
	emulate zsh -c 'path=($pathar $path)'
else
	path=("${pathar[@]}" "$PATH")
	path="$( printf '%s:' "${path[@]%/}" )"
	path="${path:0:-1}"
	export PATH="$path"
	unset path
fi
unset pathar

export PROFILE_SOURCED=true

# vim: set ft=sh ts=4 sw=4 sts=0 tw=0 noet :
# EOF