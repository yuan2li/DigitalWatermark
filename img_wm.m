function  [PSNR, WR] = img_wm(wmdata_pre, data, wmdata)
% img_wm DCT交换域技术
% wmdata_pre 加密后的水印序列
% data 原始图像数据
% wmdata 原始水印序列
% PSNR 峰值信噪比
% WR 数据误码率

% 嵌入水印
data_img = img_embeb(wmdata_pre, data);
% 得到嵌入水印的图像
file = 'embed_wm2.bmp';
imwrite(data_img, file, 'bmp');

% 提取水印
wmdata_img = img_extract(wmdata_pre, data, data_img);
% 得到提取出的水印图像
file = 'watermark2.bmp';
imwrite(wmdata_img, file, 'bmp');

% 对提取出的水印进行后处理解密
wmdata_post = post_process(wmdata_img);
% 得到解密后的水印图像
file = 'decode_wm2.bmp';
imwrite(wmdata_post, file, 'bmp');

% 水印不可见性测试
% 计算峰值信噪比
PSNR = psnr(data, data_img);
% 计算数据误码率
WR = wr_calculate(wmdata, wmdata_post);
