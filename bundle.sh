rm -rf /c/temp/mimum
rm  /c/temp/mimum.zip
mkdir /c/temp/mimum
echo Copying files
cp -r . /c/temp/mimum/
cd /c/temp/mimum/
rm bundle.sh
rm -rf .git
rm -rf build cmake src
cd bin
rm -rf Debug
mv Release/* .
cd Mumble
rm mumble.lock
cat mumble.ini | grep -v certificate > m2.ini
mv m2.ini mumble.ini
cd ../../../
zip -r mimum.zip mimum
