function img_test()
% DCT变换域技术水印鲁棒性测试
% data_attack为攻击后的载体图像数据
disp('---DCT变换域技术水印鲁棒性测试---');
clear;

file = 'embed_wm2.bmp';
data_test = imread(file); % 待测试的载体图像数据

% 读取原始载体图像数据
[file, path] = uigetfile('*.bmp', '打开原始载体图像');
if isequal(file, 0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path, file)]);
end
data = imread(file);
% 显示原始载体图像
subplot(2, 3, 1);
imshow(file);
title('原始载体图像');

% 读取原始水印序列
[file, path] = uigetfile('*.bmp', '打开原始水印图像');
if isequal(file, 0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path, file)]);
end
wmdata = imread(file);
% 显示原始水印图像
subplot(2, 3, 4);
imshow(file);
title('原始水印图像');

% 中值滤波攻击
data_attack = medfilt2(data_test);
% 显示攻击后的载体图像
file = 'medfilt_img.bmp';
imwrite(data_attack, file, 'bmp');
subplot(2, 3, 2);
imshow(file);
title('中值滤波攻击后的载体图像');
% 计算峰值信噪比
PSNR = psnr(data_attack, data);
fprintf('中值滤波攻击后PSNR: %.3f\n', PSNR);
% 读取加密后水印序列
file = 'encode_wm.bmp';
wmdata_pre =imread(file);
% 提取并还原水印
wmdata_img = img_extract(wmdata_pre, data, data_attack);
wmdata_post = post_process(wmdata_img);
file = 'medfilt_img_wm.bmp';
imwrite(wmdata_post, file, 'bmp');
% 显示提取的水印图像
subplot(2, 3, 5);
imshow(file);
title('中值滤波攻击后提取的水印图像');
% 计算数据误码率
WR = wr_calculate(wmdata, wmdata_post);
fprintf('中值滤波攻击后WR: %.3f\n', WR);

% 椒盐噪声攻击
data_attack = imnoise(data_test, 'salt & pepper', 0.02);
% 显示攻击后的载体图像
file = 'noise_img.bmp';
imwrite(data_attack, file, 'bmp');
subplot(2, 3, 3);
imshow(file);
title('椒盐噪声攻击后的载体图像');
% 计算峰值信噪比
PSNR = psnr(data_attack, data);
fprintf('椒盐噪声攻击后PSNR: %.3f\n', PSNR);
% 提取并还原水印
wmdata_img = img_extract(wmdata_pre, data, data_attack);
wmdata_post = post_process(wmdata_img);
file = 'noise_img_wm.bmp';
imwrite(wmdata_post, file, 'bmp');
% 显示提取的水印图像
subplot(2, 3, 6);
imshow(file);
title('椒盐噪声攻击后提取的水印图像');
% 计算数据误码率
WR = wr_calculate(wmdata, wmdata_post);
fprintf('椒盐噪声攻击后WR: %.3f\n', WR);

% 旋转攻击
% y = imrotate(x, 90);

% 尺寸变小攻击
% y = imresize(x, 0.5);