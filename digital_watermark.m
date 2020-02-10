function digital_watermark()
clear;
% 读取原始水印图像数据
[file, path] = uigetfile('*.bmp', '打开原始水印图像');
if isequal(file, 0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path, file)]);
end
wmdata = imread(file);
% 显示原始水印图像
subplot(3, 3, 1);
imshow(file);
title('原始水印图像');

% 水印预处理加密
wmdata_pre = pre_process(wmdata);
% 得到加密后的水印图像
file = 'encode_wm.bmp';
imwrite(wmdata_pre, file, 'bmp');
% 显示加密后的水印图像
subplot(3, 3, 2);
imshow(file);
title('加密后的水印图像');
% 以二进制方式读取加密后的水印序列
fileID = -1;
errmsg = '';
while fileID < 0
   disp(errmsg);
   [fileID, errmsg] = fopen(file, 'rb');
end
wmdata_bin = fread(fileID);
fclose(fileID);

% 读取载体图像数据
[file, path] = uigetfile('*.bmp', '打开载体图像');
if isequal(file, 0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path, file)]);
end
data = imread(file);
% 显示原始载体图像
subplot(3, 3, 3);
imshow(file);
title('原始载体图像');
% 以二进制形式读取载体图像文件
fileID = -1;
errmsg = '';
while fileID < 0
   disp(errmsg);
   [fileID, errmsg] = fopen(file, 'rb');
end
data_bin = fread(fileID);
fclose(fileID);

% 文件格式法
[psnr, wr] = file_wm(wmdata_bin, data_bin, data, wmdata);
fprintf('文件格式法PSNR: %.3f\n', psnr);
fprintf('文件格式法WR: %.3f\n', wr);
% 显示嵌入水印的载体图像
file = 'embed_wm1.bmp';
subplot(3, 3, 4);
imshow(file);
title('文件格式法嵌入水印的载体图像');
% 显示提取出的水印图像
file = 'watermark1.bmp';
subplot(3, 3, 5);
imshow(file);
title('文件格式法提取出的水印图像');
% 显示解密后的水印图像
file = 'decode_wm1.bmp';
subplot(3, 3, 6);
imshow(file);
title('文件格式法提取出的水印解密后图像');

% DCT交换域技术
[psnr, wr] = img_wm(wmdata_pre, data, wmdata);
fprintf('DCT变换域技术PSNR: %.3f\n', psnr);
fprintf('DCT变换域技术WR: %.3f\n', wr);
% 显示嵌入水印的载体图像
file = 'embed_wm2.bmp';
subplot(3, 3, 7);
imshow(file);
title('DCT交换域技术嵌入水印的载体图像');
% 显示提取出的水印图像
file = 'watermark2.bmp';
subplot(3, 3, 8);
imshow(file);
title('DCT变换域技术提取出的水印图像');
% 显示解密后的水印图像
file = 'decode_wm2.bmp';
subplot(3, 3, 9);
imshow(file);
title('DCT变换域技术提取出的水印解密后图像');
