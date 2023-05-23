### 注：是收费的，20人/年，x00Rmb
## wps文档在线编辑服务
[https://open.wps.cn/docs/wwo/access-know](https://open.wps.cn/docs/wwo/access-know)
## demo下载
[https://open.wps.cn/docs/wwo/access/sdk-demo](https://open.wps.cn/docs/wwo/access/sdk-demo)
## 工作流程介绍
**先做几个假设**
- 前端vue发布的地址:
http://xxx.com/vue-wps/ 
- 你的docx文件地址：
http://xxx.com/docx/xx?filename="测试.docx"&Expires=1596251636&Signature=hMHA16%2BBWwjSycLk055EOMgbGtw%3D
- 你的docx文件地址url编码一次后地址：
http%3A%2F%2Fxxx.com%2Fdocx%2Fxx%3Ffilename%3D%22%E6%B5%8B%E8%AF%95.docx%22%26Expires%3D1596251636%26Signature%3DhMHA16%252BBWwjSycLk055EOMgbGtw%253D
- 你的后端地址：
http://xxx.com/wps-demo/

**然后介绍一下工作流程**
1. 点击你要编辑的文件得到一个前端vue地址并传入必要参数
- 当前登录人token
- 文件地址 或者 可以拿到文件地址的记录id
- 我在使用中还传入了自定义参数**记录类型**以适应多张记录表数据
- 我在使用中还传入了自定义参数**编辑还是预览**
- 最后生成的地址如下：
前端地址?filePath=文件地址&readOnly=编辑
http://xxx.com/vue-wps?filePath=http://xxx.com/docx/xx?filename="测试.docx"&Expires=1596251636&Signature=hMHA16%2BBWwjSycLk055EOMgbGtw%3D&readOnly=false
**？？？**
**那么一开始你就已经错了！请使用url编码后的地址进行参数传递：**
前端地址?filePath=文件地址url编码一次后地址&readOnly=编辑
http://xxx.com/vue-wps?filePath=http%3A%2F%2Fxxx.com%2Fdocx%2Fxx%3Ffilename%3D%22%E6%B5%8B%E8%AF%95.docx%22%26Expires%3D1596251636%26Signature%3DhMHA16%252BBWwjSycLk055EOMgbGtw%253D&readOnly=false
- 或者生成的地址如下（不传递文件路径，使用记录id的方式）
前端地址?type=记录类型&记录file_id=1231512312&readOnly=编辑
http://xxx.com/vue-wps?type=share_dic&file_id=1231512312&readOnly=false
2. 前端拿到参数该干嘛？
- 把token告诉wps,参考官方
[https://open.wps.cn/docs/wwo/access/api-list](https://open.wps.cn/docs/wwo/access/api-list)
- 在调用 **api/v1/file/getViewUrlWebPath** 把其它自定义的参数带走
3. 前端来调用后端 **api/v1/file/getViewUrlWebPath** 了
- 这里的返回值是wps.util.Token
- Token里面最重要的是wpsUrl
String wpsUrl = wpsUtil.getWpsUrl
- wpsUrl里面最重要的是_w_signature，**测试过程中经常签名错误就找这里，主要看_w_filepath的urlencode,decode是否一致**
- **在wpsUrl里面添加你的自定义参数，你传给他，他再在后面v1/3rd/的接口调用的时候回传给你**
4. 接下来就是后端和wps的工作了，在这之前，我们要先处理我们自己的token
```
Reques Headers:
  x-wps-weboffice-token: your token
```
wps官网说了：前端通过他指定的方式设置了用户token，它会在请求我们后端的时候在头部用**x-wps-weboffice-token**传回来。不多说了，自己处理。
5.wps调用**v1/3rd/file/info**
先看wps需要我们提供的东西
```
        // 构建默认user信息
        UserDTO wpsUser = new UserDTO(
                UserContext.getId().toString(), UserContext.getName(), permission, "https://zmfiletest.oss-cn-hangzhou.aliyuncs.com/user0.png"
        );
        // 构建文件
        WpsFileDTO file = new WpsFileDTO(
                _w_fileid, FileUtil.getFileName(filePath),
                1, 0, "-1", new Date().getTime(), filePath,
                // 默认设置为无水印，只读权限
                new UserAclBO(), new WatermarkBO()
        );
        return new HashMap<String, Object>() {
            {
                put("file", file);
                put("user", wpsUser);
            }
        };
```
- 这里需要处理一些你自己的逻辑
- 没有直接传递filePath的需要通过记录id和type得到filePath了
- readOnly=false的需要对用户鉴权，即：当前用户**x-wps-weboffice-token: your token**是否有编辑文件的权限
- **记坑 FileUtil.getFileName(filePath)方法，filePath = URLDecoder.decode(filePath, "UTF-8"); 当然如果你的记录里面有就直接给。**
5. wps调用**v1/3rd/user/info**
- 这里没什么可说的
6. wps调用文件保存**v1/3rd/file/save**
- 这里也没什么可说的
### 重复记录上面的坑
1.  前端地址?filePath=**文件地址url编码一次后地址**&readOnly=编辑
2. **x-wps-weboffice-token**处理
3. 签名错误找 **api/v1/file/getViewUrlWebPath** 接口 _w_filepaht 的 urlencode,decode
4. **FileUtil.getFileName(filePath)**方法对于网络文件地址的处理