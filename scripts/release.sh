#!/bin/bash

repo=`echo $PWD | grep -o '[^/]*$'`

description="$repo release $1"
echo "publishing $description"

git tag -f -a "$1" -m "$description"

git push --follow-tags

code=$(curl -s -o /dev/null -w "%{http_code}" \
	-X POST -d "{\"tag_name\":\"$1\", \"target_commitsh\":\"master\", \"name\":\"$1\", \"body\":\"$description\"}" \
	-H "Accept: application/vnd.github.v3+json" \
	-H "Authorization: token $GITHUB_API_TOKEN" \
	"https://api.github.com/repos/ironman9967/$repo/releases" \
)

if [ $code == "201" ]
then
	echo "$description created successfully"
else
	echo "ERROR: $code"
	exit 1
fi
