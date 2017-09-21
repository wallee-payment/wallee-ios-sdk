  #!/usr/bin/env bash

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -v|--verbose)
    VERBOSE=true
    ;;
    -p|--publish)
    DO_PUBLISH=true
    ;;
    -f|--force)
    FORCE=true
    ;;
    *)
    if ! [[ $key =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      echo "the version number has to be in format 1.0.0  aborting..."
      exit 0
    fi
    VERSION=$key
    ;;
esac
shift # past argument or value
done

if [[ -n "$(git status --porcelain)" && ! $FORCE ]]; then
  echo "this command should be run on a clean repository (use -f to force anyway). aborting..."
  exit 0
else
  git status --porcelain
fi

GIT_VERSION_NUMBER="v$VERSION"
PLIST_PATH="../WalleeSDK/WalleeSDK/Info.plist"
PODSPEC_PATH="../WalleeSDK.podspec"

sed -i '' "s/\(s\.version.*\)\'\(.*\)\'/\1\'$VERSION\'/g" $PODSPEC_PATH

if [ $VERBOSE ]; then
  echo "plist before parsing:"
  plutil -p $PLIST_PATH
fi

FLAG=CFBundleShortVersionString
plutil -replace $FLAG -string $VERSION $PLIST_PATH

FLAG=CFBundleVersion
plutil -replace $FLAG -string $VERSION $PLIST_PATH

if [[ $VERBOSE ]]; then
  echo "plist after parsing:"
  plutil -p $PLIST_PATH
fi

if ! [[ $DO_PUBLISH ]]; then
  echo "version numbers have been increased. you have to commit and push to travis manually or use the -p option..."
  exit 0
fi

COMMIT_MESSAGE="Version Bump to $GIT_VERSION_NUMBER"
git commit -am $COMMIT_MESSAGE
git tag -a $GIT_VERSION_NUMBER -m
git push --tags

echo "Tag $GIT_VERSION_NUMBER pushed to origin"