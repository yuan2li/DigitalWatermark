function  [PSNR, WR] = file_wm(wmdata_bin, data_bin, data, wmdata)
% file_wm 文件格式法
% wmdata_bin 以二进制形式读取的加密后的水印序列
% data_bin 以二进制形式读取的原始载体图像数据序列
% wmdata 原始水印图像数据
% data 原始载体图像数据
% PSNR 峰值信噪比
% WR 数据误码率

% 嵌入水印
data_bin1 = file_embeb(wmdata_bin, data_bin);
% 得到嵌入水印的载体图像
file = 'embed_wm1.bmp';
fileID = fopen(file, 'w');
fwrite(fileID, data_bin1);
fclose(fileID);
data_file = imread(file); % 读取嵌入水印的载体图像数据

% 提取水印
wmdata_bin2 = file_extract(wmdata_bin, data_bin1);
% 得到提取出的水印图像
file = 'watermark1.bmp';
fileID = fopen(file, 'w');
fwrite(fileID, wmdata_bin2);
fclose(fileID);

% 读取提取的水印图像数据
wmdata_file = imread(file);
% 对提取出的水印进行后处理解密
wmdata_post = post_process(wmdata_file);
% 得到解密后的水印图像
file = 'decode_wm1.bmp';
imwrite(wmdata_post, file, 'bmp');

% 水印不可见性测试
% 计算峰值信噪比
PSNR = psnr(data_file, data);
% 计算数据误码率
WR = wr_calculate(wmdata, wmdata_post);
