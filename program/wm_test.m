function wm_test()
% 水印加解密测试模块

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
subplot(1, 3, 1);
imshow(file);
title('原始水印图像');

% 水印预处理加密
wmdata_pre = pre_process(wmdata);
% 显示加密后的水印图像
subplot(1, 3, 2);
imshow(wmdata_pre);
title('加密后的水印图像');

% 对水印进行后处理解密
wmdata_post = post_process(wmdata_pre);
% 显示解密后的水印图像
subplot(1, 3, 3);
imshow(wmdata_post);
title('解密后的水印图像');