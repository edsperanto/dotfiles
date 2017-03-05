# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/edward/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="pygmalion"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(osx git npm brew github node sublime)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

function gotoWeek() {
   cd /Users/Edward/ee160/week$1
   if [ ! -z $2 ]; then
      findDirectory $2
   else
      ls
   fi
}

function goUpDirectory() {
   if [ -z $1 ]; then
      cd ..
   else
      local amt=$1
      while ((amt > 0)); do
         ((amt=amt-1))
         cd ..
      done
   fi
}

function findDirectory() {
   for d in */; do
      local directory=$(echo $d | tr '[:upper:]' '[:lower:]')
      local search=$(echo $1 | tr '[:upper:]' '[:lower:]')
      if [[ $directory =~ $search ]]; then
         cd $d
         ls
         break
      fi
   done
}

function newGithubRepo() {
   local json="{\"name\":\"$1\"}"
   mkdir $1
   cd $1
   touch .gitkeep
   git init
   git add .gitkeep
   git remote add origin "git@github.com:edsperanto/$1.git"
   git commit -m "initial commit"
   curl -u 'edsperanto' https://api.github.com/user/repos -d "$json"
   git push --set-upstream origin master
}

function tmuxSession() {
		set -e

		dump() {
			local d=$'\t'
			tmux list-windows -a -F "#S${d}#W${d}#{pane_current_path}"
		}

		save() {
			dump > ~/.tmux-session
		}

		terminal_size() {
			stty size 2>/dev/null | awk '{ printf "-x%d -y%d", $2, $1 }'
		}

		session_exists() {
			tmux has-session -t "$1" 2>/dev/null
		}

		add_window() {
			tmux new-window -d -t "$1:" -n "$2" -c "$3"
		}

		new_session() {
			cd "$3" &&
			tmux new-session -d -s "$1" -n "$2" $4
		}

		restore() {
			tmux start-server
			local count=0
			local dimensions="$(terminal_size)"

			while IFS=$'\t' read session_name window_name dir; do
				if [[ -d "$dir" && $window_name != "log" && $window_name != "man" ]]; then
					if session_exists "$session_name"; then
						add_window "$session_name" "$window_name" "$dir"
					else
						new_session "$session_name" "$window_name" "$dir" "$dimensions"
						count=$(( count + 1 ))
					fi
				fi
			done < ~/.tmux-session

			echo "restored $count sessions"
		}

		case "$1" in
		save | restore )
			$1
			;;
		* )
			echo "valid commands: save, restore" >&2
			exit 1
		esac
}

# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# Frequent directories
alias h='cd ~;ls'
alias dl='cd ~/DevLeague;ls'
alias t='cd ~/tmp;ls'
alias j='cd ~/Projects'

# Custom shortcuts
alias w=gotoWeek
alias b=goUpDirectory
alias nr=newGithubRepo
alias f=findDirectory

# Tmux shortcuts
alias tmux-session=tmuxSession
