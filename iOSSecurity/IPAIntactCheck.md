# 应用完整性检查

场景：在越狱手机中，直接替换资源文件，然后重新启动app，加载了被替换的资源，app没有警告。

通过网络调查，目前市面上的方法大致分为三种：

* 将app包中的CodeResources文件放到服务端，app启动时下载与本地bundle文件夹内的文件做比较
* 检测app的cryptid值来看是否加密
* 对比资源文件的md5值

第一种方法中提到的CodeResources文件是Xcode在对IPA包做签名时的产物。

![CodeResource](/img/codeResource.png)

该文件为plist文件，files中存储了资源文件在签名之后的加密值，最终以base64编码显示，但是解码之后得到的仍然是乱码，因此只能在打包后将此文件交给后端，app启动后通过网络请求下载该文件，然后与本地的文件做比较。

第二种办法，由于通过App Store上架的应用，苹果会对IPA包做数字加密处理，通过比较cryptid可以来判断该应用是否为App Store下载的应用，但是对于直接替换资源文件，不会对加密产生影响，因此该方法只能用于验证加密。

```c
#if TARGET_IPHONE_SIMULATOR && !defined(LC_ENCRYPTION_INFO)
#define LC_ENCRYPTION_INFO 0x21

struct encryption_info_command {
    uint32_t cmd;
    uint32_t cmdsize;
    uint32_t cryptoff;
    uint32_t cryptsize;
    uint32_t cryptid;
};
#endif

int main (int argc, char *argv[]);
static BOOL isEncrypted () {
    const struct mach_header *header;
    Dl_info dlinfo;
    /* Fetch the dlinfo for main() */
    if (dladdr(main, &dlinfo) == 0 || dlinfo.dli_fbase == NULL) {
        //NSLog(@"Could not find main() symbol (very odd)");
        return NO;
    }
    header = dlinfo.dli_fbase;
    /* Compute the image size and search for a UUID */
    struct load_command *cmd = (struct load_command *) (header+1);
    for (uint32_t i = 0; cmd != NULL && i < header->ncmds; i++) {
        /* Encryption info segment */
        if (cmd->cmd == LC_ENCRYPTION_INFO) {
            struct encryption_info_command *crypt_cmd = (struct encryption_info_command *) cmd;
            /* Check if binary encryption is enabled */
            if (crypt_cmd->cryptid < 1) {
                /* Disabled, probably pirated */
                return NO;
            }
            /* Probably not pirated <-- can't say for certain, maybe theres a way around it */
            return YES;
        }
        cmd = (struct load_command *) ((uint8_t *) cmd + cmd->cmdsize);
    }
    /* Encryption info not found */
    return NO;
}
```

第三种办法，在编译期间，使用shell命令，遍历所有资源图片，并计算其MD5值，然后以图片名字为key，写入一个plist文件中，app启动后，遍历自身bundle资源图片，进行MD5计算，然后比较。但是由于Xcode默认开启PNG图片压缩处理，需要将其关闭，现有应用IPA包将增加0.3MB的空间。

安卓端所采用的方法，为计算整个APK包的文件大小，app启动后，获取APK包的路径，然后计算其MD5的值，iOS在使用这一方法时，读取bundle路径的.app文件，在转为NSData的时候会失败，因为系统只允许对未打开的文件进行操作。