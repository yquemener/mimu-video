rm -rf /c/temp/mimu
rm  /c/temp/mimu.zip
mkdir /c/temp/mimu
echo Copying files
cp -r . /c/temp/mimu/
cd /c/temp/mimu/
rm -rf CMakeLists.txt debug.txt Dockerfile LICENSE.txt minetest.conf misc/  po/
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
zip -r mimu.zip mimu
