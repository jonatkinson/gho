#!/bin/bash

# Initialize flag variables
verbose=0

# Parse command-line options
while getopts "v" option; do
    case "${option}" in
        v)
            verbose=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

# Function to recursively check for .git directory in current and parent directories
function check_git() {
    local dir="$1"
    while [[ "$dir" != "" && "$dir" != "$HOME" ]]; do
        if [[ -d "${dir}/.git" ]]; then
            [[ $verbose -eq 1 ]] && echo "Found .git repository at $dir"
            echo "${dir}"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    echo "This directory or any parent directories are not a .git repository" >&2
    return 1
}

# Get the current directory
current_dir="$(pwd)"

# Check if current directory (or any parent directory) is a git repository
git_dir=$(check_git "$current_dir")
if [[ $? -eq 0 ]]; then
    # Parse the Github URL from the .git/config
    github_url=$(grep "url" "${git_dir}/.git/config" | head -n 1 | awk -F'=' '{ print $2 }' | xargs)
    github_url=${github_url/ssh:\/\/git@github.com\//https:\/\/github.com\/}
    github_url=${github_url/git@github.com:/https:\/\/github.com\/}
    github_url=${github_url/.git/}

    [[ $verbose -eq 1 ]] && echo "Github URL is: $github_url"

    # Append the relevant path if an argument was supplied
    case "$1" in
        pr)
            github_url="${github_url}/pulls"
            ;;
        i)
            github_url="${github_url}/issues"
            ;;
        "")
            ;;
        *)
            echo "Invalid argument: $1" >&2
            exit 1
            ;;
    esac

    # Check if running inside WSL
    if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
        [[ $verbose -eq 1 ]] && echo "Running inside WSL, using cmd.exe to open URL"
        cmd.exe /c start "$github_url"
    # Open the Github URL in Safari if it exists, otherwise use $BROWSER
    elif [ -d "/Applications/Safari.app" ]; then
        open -a Safari "$github_url"
    elif [[ -n $BROWSER ]]; then
        $BROWSER "$github_url"
    else
        echo "Unable to find a browser to open Github URL" >&2
        exit 1
    fi
else
    exit 1
fi
