function file_test()
% 文件格式法水印鲁棒性测试
% data_attack为攻击后的载体图像数据

disp('---文件格式法水印鲁棒性测试---');
clear;

file = 'embed_wm1.bmp';
data_test = imread(file); % 待测试的已嵌入水印的载体图像数据
% 以二进制方式读取加密后的水印序列
file = 'encode_wm.bmp';
fileID = -1;
errmsg = '';
while fileID < 0
   disp(errmsg);
   [fileID, errmsg] = fopen(file, 'rb');
end
wmdata_bin = fread(fileID);
fclose(fileID);

% 读取原始载体图像数据
[file, path] = uigetfile('*.bmp', '打开原始载体图像');
if isequal(file, 0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path, file)]);
end
data = imread(file);
% 显示原始载体图像
subplot(1, 3, 1);
imshow(file);
title('原始载体图像');

% 中值滤波攻击
data_attack = medfilt2(data_test);
% 显示攻击后的载体图像
file = 'medfilt_file.bmp';
imwrite(data_attack, file, 'bmp');
subplot(1, 3, 2);
imshow(file);
title('中值滤波攻击后的载体图像');
% 以二进制方式读取攻击后的载体图像数据序列
fileID = -1;
errmsg = '';
while fileID < 0
   disp(errmsg);
   [fileID, errmsg] = fopen(file, 'rb');
end
data_bin = fread(fileID);
fclose(fileID);
% 计算峰值信噪比
PSNR = psnr(data_attack, data);
fprintf('中值滤波攻击后PSNR: %.3f\n', PSNR);
% 从攻击后的载体图像中提取水印
wmdata_bin2 = file_extract(wmdata_bin, data_bin);
file = 'medfilt_file_wm.bmp'; % 水印已被破坏，提取无效
fileID = fopen(file, 'w');
fwrite(fileID, wmdata_bin2);
fclose(fileID);

% 椒盐噪声攻击
data_attack = imnoise(data_test, 'salt & pepper', 0.02);
% 显示攻击后的载体图像
file = 'noise_file.bmp';
imwrite(data_attack, file, 'bmp');
subplot(1, 3, 3);
imshow(file);
title('椒盐噪声攻击后的载体图像');
% 以二进制方式读取攻击后的载体图像数据序列
fileID = -1;
errmsg = '';
while fileID < 0
   disp(errmsg);
   [fileID, errmsg] = fopen(file, 'rb');
end
data_bin = fread(fileID);
fclose(fileID);
% 计算峰值信噪比
PSNR = psnr(data_attack, data);
fprintf('椒盐噪声攻击后PSNR: %.3f\n', PSNR);
% 从攻击后的载体图像中提取水印
wmdata_bin2 = file_extract(wmdata_bin, data_bin);
file = 'noise_file_wm.bmp'; % 水印已被破坏，提取无效
fileID = fopen(file, 'w');
fwrite(fileID, wmdata_bin2);
fclose(fileID);