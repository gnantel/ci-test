#!/bin/bash

CURRENT_VERSION=$1
VERSION_TYPE=$2
POM_FILE=$3

if [[ -z $CURRENT_VERSION || ($VERSION_TYPE != 'minor' && $VERSION_TYPE != 'patch') || -z $POM_FILE ]]; then
    echo "Usage: $0 <current-version> <minor|patch> <pom-file>"
    exit 1
fi

BRANCH_NAME=main
if [[ $VERSION_TYPE == 'patch' ]]; then
    BRANCH_NAME=$(echo $CURRENT_VERSION | sed -r s/^\([0-9]+\.[0-9]+\.\)[0-9]+$/\\1x/)
fi

CURRENT_VERSION_COMPONENT=$(echo $CURRENT_VERSION | sed -r s/^\[0-9]+\.[0-9]+\.\([0-9]+\)$/\\1/)
NEW_VERSION_COMPONENT=$((CURRENT_VERSION_COMPONENT + 1))
NEW_VERSION=$(echo $CURRENT_VERSION | sed -r s/^\([0-9]+\.[0-9]+\)\.[0-9]+$/\\1.$NEW_VERSION_COMPONENT/)

sed -i 's/<revision>$CURRENT_VERSION<\/revision>/<revision>$NEW_VERSION<\/revision>/' $POM_FILE

MESSAGE="Bump $BRANCH_NAME $VERSION_TYPE version to $NEW_VERSION"
DEV_BRANCH_NAME=feature/bump-$VERSION_TYPE-version-in-$BRANCH_NAME

echo Token: $GITHUB_TOKEN

git checkout -b $DEV_BRANCH_NAME
git commit $POM_FILE -m "$MESSAGE"
git push -u origin $DEV_BRANCH_NAME
gh pr create --base $BRANCH_NAME --title "$MESSAGE"
gh pr --approve 
gh pr merge --rebase --auto

