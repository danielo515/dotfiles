#!/bin/bash

set -ex

if [ -z "$1" ]; then
  echo "Usage: $0 <SpoonName>"
  exit 1
fi

SPOON_NAME="$1"
REPO_NAME="$SPOON_NAME.spoon"
GITHUB_USER="danielo515"
GITHUB_EMAIL="rdanielo@gmail.com"
HOMEPAGE="https://github.com/$GITHUB_USER/$REPO_NAME"

HS_DIR="$(chezmoi source-path)/dot_hammerspoon"
SPOON_TEMPLATE="$HS_DIR/init.tpl"
# Set the Spoon directory path
SPOON_DIR="$HS_DIR/Spoons/$REPO_NAME"


# Check if the repository already exists on GitHub
REPO_EXISTS=$(gh repo view "$GITHUB_USER/$REPO_NAME" >/dev/null 2>&1; echo $?)

if [ "$REPO_EXISTS" -eq 0 ]; then
  echo "Repository $GITHUB_USER/$REPO_NAME already exists."
else
  # Create the GitHub repository
  echo "Creating repository $GITHUB_USER/$REPO_NAME..."
  gh repo create "$REPO_NAME" --public -l MIT
fi

# Check if submodule exists
if ! git submodule status | grep -q "$SPOON_DIR"; then
  # Add the repository as a submodule
  git submodule add -f "git@github.com:$GITHUB_USER/$REPO_NAME.git" "$SPOON_DIR"

  # Commit the submodule
  git add ".gitmodules" "$SPOON_DIR"
  git config --local user.name "$GITHUB_USER"
  git config --local user.email "$GITHUB_EMAIL"
  # git commit -m "Add $REPO_NAME submodule"

  git submodule sync --recursive "$SPOON_DIR"
  # Initialize the Spoon with the Hammerspoon template at the desired path
  hs -c "hs.spoons.newSpoon('$SPOON_NAME', '$SPOON_DIR', { author = '$GITHUB_USER <$GITHUB_EMAIL>', homepage = '$HOMEPAGE' }, '$SPOON_TEMPLATE')"
  cd "$SPOON_DIR"
  git add .
  git commit -m "Initial commit"
  git push -u origin master

  echo "Done. $REPO_NAME submodule has been created and added to the current repository."
else
  echo "$REPO_NAME submodule already exists. Skipping submodule creation."
fi
