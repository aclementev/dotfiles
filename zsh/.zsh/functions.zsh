# Custom functions for Alvaro
light_mode() {
    # TODO(alvaro): Change the iTerm2 profile (if applicable)
    echo 'light' > $HOME/.alvaro_screen_mode
}

dark_mode() {
    # TODO(alvaro): Change the iTerm2 profile (if applicable)
    echo 'dark' > $HOME/.alvaro_screen_mode
}

# Copy the pwd to the clipboard
# TODO(alvaro): Make this platform independent/Support other platforms
wd() {
    pwd | tr -d '\n' | pbcopy
}

# Quickly format as JSON the contents of the clipboard
format-json() {
    pbpaste | jq '.' | pbcopy
}


# Parse psql to csv
psql-to-csv() {
    # Steps:
    #   1. Remove '-----' and (N rows) lines
    #   2. Transform '|' to ','
    #   3. Strip whitespace from begin/end of line
    #   4. Remove trailing whiteshape in cell (alignment)
    #   5. Remove beginning whiteshape in cell (alignment)
    sed -E '/(^-+)|(\([[:digit:]]+ rows?\))/d; s/\|/,/g; s/(^[[:space:]]+)|([[:space:]]+$)//g; s/[[:space:]]+,/,/g; s/,[[:space:]]+/,/g' $1
}

# Docker related
# Purge all the containers running and stopped
docker-purge() {
    docker ps -aq | xargs docker rm -f
}

# cht.sh
# A great API for quick questions about many programming languages
# (see https://github.com/chubin/cheat.sh)
cheat() {
    if [ "$#" -lt 2 ]; then
        echo "usage: cheat [lang] [question]"
        return
    fi
    LANG=$1
    QUESTION=$(echo "${@:2}" | tr ' ' '+')
    curl "cht.sh/${LANG}/${QUESTION}?Q"
}

cheatpy() {
    cheat python $@
}

cheatlua() {
    cheat lua $@
}

cheatjs() {
    cheat javascript $@
}

cheatbash() {
    cheat bash $@
}

pip-dev() {
    # Check if `uv` is installed
    if [[ -x "$(command -v uv)" ]]; then
        uv pip install flake8 black isort mypy 'python-lsp-server[all]' python-lsp-black python-lsp-isort pylsp-mypy
    fi
    pip install flake8 black isort mypy 'python-lsp-server[all]' python-lsp-black python-lsp-isort pylsp-mypy
}


# Working with AWS
ecr-latest-tag() {
  ECR_REPO="$1"

  if [[ -z "$ECR_REPO" ]]; then
    echo "Usage: $0 <ecr-repo>"
    return 1
  fi

  AWS_PAGER= aws ecr describe-images --repository-name "$ECR_REPO" --filter 'tagStatus=TAGGED' --query 'sort_by(imageDetails, & imagePushedAt)[-1].imageTags[0]' --output text
}
