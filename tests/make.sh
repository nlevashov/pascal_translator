rm -f 3ac pasto3ac

cd ../3ac_interpreter/
make
cp 3ac ../tests/
make clean

cd ../pascal_translator/
make
cp pasto3ac ../tests/
make clean

