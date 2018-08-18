# get the latest code
# git checkout master
# git reset --hard origin/master
# git clean -df

# do the podspec stuff
# npm install -g podspec-bump #uncomment if you need the node package
podspec-bump -w

# commit the podspec bump
git commit -am "[CI-Skip] publishing pod version: `podspec-bump --dump-version`" 
git tag "`podspec-bump --dump-version`"
git push origin HEAD -u $(podspec-bump --dump-version)
git reset --hard
git clean -df
curl --data "{\"tag_name\": \"`podspec-bump --dump-version`\",\"target_commitish\": \"master\",\"name\": \"`podspec-bump --dump-version`\",\"body\": \"Release of version `podspec-bump --dump-version`\",\"draft\": false,\"prerelease\": false}" "https://api.github.com/repos/Tyler-Keith-Thompson/UIUTest/releases?access_token=$PERSONAL_ACCESS_TOKEN"
pod trunk push UIUTest.podspec