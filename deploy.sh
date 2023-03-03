set -e

npm run build

cd dist

git init
git add -A
git commit -m 'deploy'

git push -f https://github.com/Midas010629/text_file_manger.git master:gh-pages

cd -