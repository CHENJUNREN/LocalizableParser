# LocalizableParser

多语言文案 CSV 文件转 Localizable.strings 文件命令行工具



## 如何使用

本项目是由 Swift Package Manager 以及 [ArgumentParser](https://github.com/apple/swift-argument-parser) 框架实现, 参考如下步骤编译成二进制文件并使用:

```shell
$ swift build --configuration release
$ cp -f .build/release/LocalizableParser /usr/local/bin/lparser
$ lparser --help
```



## CSV 文件格式

| 简体中文 | 繁体中文 | 英文  |
| :------- | -------- | ----- |
| 你好     | 你好     | Hello |

**注意事项:**

- 建议第一行用于标识每列文案对应的语言
	- 生成的 **Localizable.strings** 文件后缀会用此内容作为标识
- 建议第一列填写 App 默认语言对应的文案
	- 生成的 **Localizable.strings** 文件里面的键值对的 key 都是用第一列文案作为标识

- 默认会把文案中的 `xxx` 替换成 `%@`
