# .bashrc

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

# Frequent directories
alias h='cd ~;ls'
alias j='cd ~/Projects'

# Custom shortcuts
alias b=goUpDirectory
alias nr=newGithubRepo
alias f=findDirectory

# Tmux shortcuts
alias tmux-session=tmuxSession
