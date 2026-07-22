#!/usr/bin/env bash

set -euo pipefail

REMOTE="origin"

echo "Fetching latest tags..."
git fetch --tags "$REMOTE"

# Get latest tag matching v*.*.*
LATEST_TAG=$(git tag --list "v*.*.*" --sort=-v:refname | head -n1)

if [[ -z "$LATEST_TAG" ]]; then
    echo "No existing tags found. Starting from v0.1.0"
    NEW_TAG="v0.1.0"
else
    echo "Latest tag: $LATEST_TAG"

    VERSION="${LATEST_TAG#v}"

    IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"

    # Increment minor version
    MINOR=$((MINOR + 1))
    PATCH=0

    NEW_TAG="v${MAJOR}.${MINOR}.${PATCH}"
fi

echo "Creating tag: $NEW_TAG"

git tag "$NEW_TAG"

echo "Pushing tag to $REMOTE..."

git push "$REMOTE" "$NEW_TAG"

echo "Successfully created and pushed $NEW_TAG"