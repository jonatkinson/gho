# gho

The `gho` script (GitHub Opener) is a Bash utility that identifies if the current or any parent directory is a Git repository. If it is, the script extracts the GitHub URL of the repository from its `.git/config` file. It then attempts to open the repository in Safari, or in the web browser specified by the `$BROWSER` environment variable if Safari is unavailable.

## Installation

Clone the repository where the `gho` script is hosted:

    git clone https://github.com/jonatkinson/gho && cd gho

Finally, copy the gho script to /usr/local/bin to make it globally accessible, and then executable. This operation might require sudo.

    sudo cp gho /usr/local/bin
    sudo chmod + /usr/local/bin/gho

## Usage

    gho [-v] [command]

### Options

- -v or --verbose: Use this flag for the script to output informational messages as it runs. If it isn't set, the script operates quietly, only outputting error messages when they occur.

### Commands

- `pr`: If this command is supplied, the script opens the Pull Request page for the GitHub repository.
- `i`: If this command is supplied, the script opens the Issues page for the GitHub repository.
If no command is supplied, the script opens the main page for the GitHub repository.

## Example Usage

    gho -v pr

In this example, the script will output informational messages as it runs and will open the Pull Request page for the GitHub repository in the web browser.