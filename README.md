项目内容
实现⽂件格式法和DCT变换域技术向BMP图像中嵌⼊⽔印并将其提取、还原的整体过程
模拟多种攻击⼿段对不同算法嵌⼊⽔印的不可⻅性、鲁棒性等性能进⾏测试

测试环境
Windows 10; MATLAB R2018a

1.程序文件目录
1）主流程部分
digital_watermark.m 水印处理主模块，分别调用文件格式法与DCT变换域技术两大模块，并显示对比结果
|-pre_process.m 水印预处理模块
|-file_wm.m 文件格式法主模块，调用水印嵌入与提取模块
||-file_embed.m 文件格式法水印嵌入模块
||-file_extract.m 文件格式法水印提取模块
|-img_wm.m DCT变换域技术主模块，调用水印嵌入与提取模块
||-img_embed.m DCT变换域技术水印嵌入模块
||-img_extract.m DCT变换域技术水印提取模块
|-post_process.m 水印后处理模块
2）测试部分
file_test.m 文件格式法性能测试模块
img_test.m DCT变换域技术性能测试模块
wm_test.m 水印加解密测试模块
-wr_calculate.m 数据误码率计算函数

2）执行过程生成文件
encode_wm.bmp 加密后的水印图像
embed_wm1.bmp 嵌入水印后的载体图像（文件格式法）
embed_wm2.bmp 嵌入水印后的载体图像（DCT变换域技术）
watermark1.bmp 提取出的未解密水印图像（文件格式法）
watermark2.bmp 提取出的未解密水印图像（DCT变换域技术）
decode_wm1.bmp 解密后的水印图像（文件格式法）
decode_wm2.bmp 解密后的水印图像（DCT变换域技术）
medfilt_file.bmp 中值滤波攻击后的嵌入水印的载体图像（文件格式法）
medfilt_img.bmp 中值滤波攻击后的嵌入水印的载体图像（DCT变换域技术）
medfilt_file_wm.bmp 中值滤波攻击后提取出的水印图像（文件格式法）
medfilt_img_wm.bmp 中值滤波攻击后提取出的水印图像（DCT变换域技术）
noise_file.bmp 椒盐噪声攻击后的载体图像（文件格式法）
noise_img.bmp 椒盐噪声攻击后的载体图像（文件格式法）
noise_file_wm.bmp 椒盐噪声攻击后提取出的水印图像（文件格式法）
noise_img_wm.bmp 椒盐噪声攻击后提取出的水印图像（文件格式法）