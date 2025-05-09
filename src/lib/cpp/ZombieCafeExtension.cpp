#include <jni.h>
#include <android/log.h>
#include <dlfcn.h>
#include <unistd.h>
#include <string>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <sys/mman.h>
#include "Memory.h"

#define LOGI(...) \
  ((void)__android_log_print(ANDROID_LOG_INFO, "zombieCafeExtension::", __VA_ARGS__))


typedef jint (*jni_OnLoad)(JavaVM* vm, void* reserved);
JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved) {
  LOGI("Zombie Cafe Extension Loaded!");
  int base = (int)Memory::getBaseAddress(); 
  
  const char* infoStr = "ZCR - %s\0";
  Memory::memcpyProtected((void*)(base + 0x1a14dc), infoStr, strlen(infoStr) + 1);

                          //http://zombiecafe.capcomcanada.com/updater/%s
  const char* updaterUrl = "https://zc.airyz.xyz/v1/updater/%s\0";
  Memory::memcpyProtected((void*)(base + 0x1a6610), updaterUrl, strlen(updaterUrl) + 1);

                    //http://zombiecafe.capcomcanada.com/x
  const char* xUrl = "https://zc.airyz.xyz/v1/x\0";
  Memory::memcpyProtected((void*)(base + 0x1a839c), xUrl, strlen(xUrl) + 1);

                      //http://zombiecafe.capcomcanada.com/zca
  const char* zcaUrl = "https://zc.airyz.xyz/v1/zca\0";
  Memory::memcpyProtected((void*)(base + 0x1a842c), zcaUrl, strlen(zcaUrl) + 1);


  Memory::setNop((void*)(base + 0x9dee8), 4);
  
  //Nop delete texture (this will cause memory leak, fix this!!!)
  Memory::setNop((void*)(base + 0x13d530), 4);
  Memory::setNop((void*)(base + 0x13d550), 4);
  Memory::setNop((void*)(base + 0x13d9e8), 4);
  Memory::setNop((void*)(base + 0x13d9ee), 4);


  /*  Fix crash when releasing texture reference also causes memory leak :( 
    #05 pc 0002eca7  /apex/com.android.runtime/lib/bionic/libc.so (scudo_free+18) (BuildId: 9e5101d790f828ae8b754029c778f7e2)
    #06 lib/arm/libZombieCafeAndroid.so (CFTextureRef::~CFTextureRef()+12)
    #07 lib/arm/libZombieCafeAndroid.so (CFTexture::releaseRef()+34)
    #08 lib/arm/libZombieCafeAndroid.so (CFTexture::~CFTexture()+4)
  */
  Memory::setNop((void*)(base + 0x0013d3ae), 4);
  Memory::setNop((void*)(base + 0x0013d3b4), 4);


  /* Patch to change Money Buy to Toxin Buy
    000ab018  d623       movs    r3, #0xd6    <-- change this offset to 0xb8
    000ab01a  5b00       lsls    r3, r3, #1   <-- prevent this leftshift
  */
  //Memory::setProtection((void*)(base + 0xab018), 50, PROT_READ | PROT_WRITE | PROT_EXEC);
  //*(char*)(base + 0x000ab018) = 0xb8;
  //Memory::setNop((char*)(base + 0x000ab01a), 2);
  
  // Patch to set getToxin to always return 100 (0x64)
  Memory::setProtection((void*)(base + 0x0011fca0), 16, PROT_READ | PROT_WRITE | PROT_EXEC);
  *(char*)(base + 0x00011fca0) = 0x64;
  *(char*)(base + 0x00011fca0 + 1) = 0x20;
  *(char*)(base + 0x00011fca0 + 2) = 0x00;
  *(char*)(base + 0x00011fca0 + 3) = 0x46;
  return JNI_VERSION_1_4;
}