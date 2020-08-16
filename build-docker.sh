#!/bin/sh

VERSION=$(git describe | sed s!release/!!g)

HOST=$1
shift
BUILD=$1
shift
NAME=waysofdarkness/wiki

REPOSITORY=$HOST/$NAME:$VERSION-$BUILD

echo "Building $REPOSITORY"

podman --cgroup-manager=cgroupfs image build . -t $REPOSITORY || exit 1
podman --cgroup-manager=cgroupfs image push $REPOSITORY || exit 1

echo "version=$VERSION-$BUILD" > variables.txt
