#! /bin/bash

rm -rf build/0.9.1/

cd ./src/

#love-release -lmw --osx-icon ../presskit/mac_icon.iscns --win-icon ../presskit/SH_headIcon.ico --osx-maintainer-name wilbefast -n divergence -r ../build/ . 
love-release -lmw --osx-maintainer-name wilbefast -n divergence -r ../build/ . 

rm -f divergence-win32.zip
rm -f divergence-win64.zip
rm -f divergence-macosx-x64.zip

cd ..
cp README.md build/0.9.1/
cd build/0.9.1/

# Add readme
zip -g divergence-macosx-x64.zip README.md
zip -g divergence-win32.zip README.md
zip -g divergence-win64.zip README.md

# Zip love version
mkdir divergence-love
cp divergence.love divergence-love
cp README.md divergence-love
cp manual.pdf divergence-love
zip -r divergence-love.zip divergence-love/
rm -rf divergence-love