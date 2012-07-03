#!/usr/bin/env bash
rm -rdf build
echo "building javascript"
coffee -c -o ./build ./src 2> /dev/null # silent on errors
echo "building documentation"
docco
