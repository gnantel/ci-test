#!/bin/bash

CURRENT_VERSION=$1
VERSION_TYPE=$2
POM_FILE=$3
BUMP_BRANCH_NAME=$4

if [[ -z $CURRENT_VERSION || ($VERSION_TYPE != 'minor' && $VERSION_TYPE != 'patch') || -z $POM_FILE || -z $BUMP_BRANCH_NAME ]]; then
    echo "Usage: $0 <current-version> <minor|patch> <pom-file> <bump-branch-name>"
    exit 1
fi

if [[ $VERSION_TYPE == 'patch' ]]; then
    CURRENT_VERSION_COMPONENT=$(echo $CURRENT_VERSION | sed -r s/^\[0-9]+\.[0-9]+\.\([0-9]+\)$/\\1/)
    NEW_VERSION_COMPONENT=$((CURRENT_VERSION_COMPONENT + 1))
    NEW_VERSION=$(echo $CURRENT_VERSION | sed -r s/^\([0-9]+\.[0-9]+\)\.[0-9]+$/\\1.$NEW_VERSION_COMPONENT/)
    BRANCH_NAME=$(echo $CURRENT_VERSION | sed -r s/^\([0-9]+\.[0-9]+\.\)[0-9]+$/\\1x/)
else
    CURRENT_VERSION_COMPONENT=$(echo $CURRENT_VERSION | sed -r s/^\[0-9]+\.\([0-9]+\)\.[0-9]+$/\\1/)
    NEW_VERSION_COMPONENT=$((CURRENT_VERSION_COMPONENT + 1))
    NEW_VERSION=$(echo $CURRENT_VERSION | sed -r s/^\([0-9]+\)\.[0-9]+\.\([0-9]+\)$/\\1.$NEW_VERSION_COMPONENT.\\2/)
    BRANCH_NAME=main
fi

echo "Updating revision in $POM_FILE from $CURRENT_VERSION to $NEW_VERSION"

grep revision $POM_FILE
sed -i "s/<revision>$CURRENT_VERSION<\/revision>/<revision>$NEW_VERSION<\/revision>/" $POM_FILE
grep revision $POM_FILE

git checkout -b $BUMP_BRANCH_NAME
git commit $POM_FILE -m "Bump $BRANCH_NAME $VERSION_TYPE version to $NEW_VERSION"
git push -u origin $BUMP_BRANCH_NAME
