#!/bin/bash

REMOTE=$1
DIR=${2:-/}  # Default to / if directory not provided

if [ -z "$REMOTE" ]; then
  echo "Usage: $0 <user@host> [directory]"
  exit 1
fi

echo "Searching for the largest file on $REMOTE in directory $DIR ..."

ssh "$REMOTE" "find \"$DIR\" -type f -exec du -h {} + 2>/dev/null | sort -hr | head -n 1"
