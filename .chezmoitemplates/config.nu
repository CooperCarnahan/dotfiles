# config.nu
#
# Installed by:
# version = "0.103.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

def --env yz [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

def push [
    message: string
] {
    let app_token = $env.PUSHOVER_APP_TOKEN?
    let user_key = $env.PUSHOVER_USER_KEY?

    if ($app_token == null) {
        print "Error: PUSHOVER_APP_TOKEN missing"
        return {status: "failed", error: "missing_app_token"}
    }

    if ($user_key == null) {
        print "Error: PUSHOVER_USER_KEY missing"
        return {status: "failed", error: "missing_user_key"}
    }

    try {
        let response = (http post https://api.pushover.net/1/messages.json --content-type multipart/form-data {
            token: $app_token
            user: $user_key
            message: $message
        })

        if $response.status == "failed" {
            print $"API Error: ($response.errors.0)"
            return $response
        }

    } catch {|e|
        return $"HTTP Error: ($e.debug)"
    }
}

alias v = nvim
alias cat = bat
alias nv = neovide
alias y  =  yadm
alias yst  =  yadm status
alias ya = yadm add
alias yc = yadm commit
alias yp = yadm push
alias yl = yadm pull
alias yco = yadm checkout
alias yd = yadm diff
alias ylg = lazygit -w ~ -g ~/.local/share/yadm/repo.git

alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../..
alias ...... = cd ../../../../..

alias lg = lazygit
alias gsur = git submodule update --init --recursive -j 12
alias gbsc = git branch --show-current
alias grh = git reset --hard
alias grb = git rebase
alias grho = git reset --hard origin/(git branch --show-current)
alias gc = git commit
alias gl = git pull
alias gp = git push
alias gco = git checkout
alias gst = git status
alias fdi = fd -IH

source ~/.cache/carapace/init.nu
use ~/.cache/starship/init.nu
source ~/.zoxide.nu
