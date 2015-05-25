#! /bin/bash

rm -rf build/0.9.2/

cd ./src/

#love-release -lmw --osx-icon ../presskit/mac_icon.iscns --win-icon ../presskit/SH_headIcon.ico --osx-maintainer-name wilbefast -n divergence -r ../build/ . 
love-release -lmw
a \
	--osx-maintainer-name wilbefast \
	--apk-maintainer-name wilbefast \
	--apk-package-name divergence \
	--apk-package-version 1.0 \
	-n divergence \
	--apk-icon ../icons/ \
	-r ../build/ . 

cd ..
cp README.md build/0.9.2/
cd build/0.9.2/

# Add readme
zip -g divergence-macosx-x64.zip README.md
zip -g divergence-win32.zip README.md
zip -g divergence-win64.zip README.md

# Zip love version
mkdir divergence-love
cp divergence.love divergence-love
cp README.md divergence-love
zip -r divergence-love.zip divergence-love/
rm -rf divergence-love