#!/bin/sh

VERSION=$(git describe | sed s!release/!!g)

HOST=$1
shift
BUILD=$1
shift
NAME=waysofdarkness/wiki

REPOSITORY=$HOST/$NAME:$VERSION-$BUILD

echo "Building $REPOSITORY"

docker image build . -t $REPOSITORY || exit 1
docker image push $REPOSITORY || exit 1

echo "version=$VERSION-$BUILD" > variables.txt
