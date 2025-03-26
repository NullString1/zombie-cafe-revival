{ pkgs ? import <nixpkgs> {} }:

(pkgs.buildFHSUserEnv {
  name = "zombiecafe-dev";
  targetPkgs = pkgs: (with pkgs; [
    pkgs.android-tools
    pkgs.ghidra
    pkgs.go
    pkgs.cmake
    pkgs.apktool
    pkgs.openjdk17-bootstrap
    (pkgs.python3.withPackages (python-pkgs: [
       python-pkgs.ipykernel
       python-pkgs.ipython
       python-pkgs.jupyter
    ]))
  ]);
  runScript = ''
    fish -C '
      echo "FHS Development environment with adb, ghidra, go, cmake, apktool, jupyter, java, python3 is ready.";
      
      function build
        cd src/lib/cpp/build;
        cmake ../ -DCMAKE_TOOLCHAIN_FILE=$HOME/Android/Sdk/ndk-bundle/build/cmake/android.toolchain.cmake -DANDROID_ABI=armeabi-v7a -DANDROID_PLATFORM=android-8;
        make;
        cd ../../../../;
        go run ./tool/build_tool/ -i src -o build/;
        cp src/lib/cpp/build/libZombieCafeExtension.so ./build/lib/armeabi/libZombieCafeExtension.so;
        apktool b ./build -o ./build/out/out.apk;
        jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore debug.keystore -storepass zombiecafe ./build/out/out.apk alias_name;
      end;
      
      function install
        adb install -r --bypass-low-target-sdk-block ./build/out/out.apk;
      end
    '
  '';
}).env
