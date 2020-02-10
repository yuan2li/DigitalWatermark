function w = img_extract(x, y, z)
% img_extract DCT变换域技术提取水印模块
% x为加密后的水印序列
% y为原始载体图像数据
% z为嵌入二重水印的载体图像数据
% w为提取出的水印序列

% 判断待提取图像是否为彩色图像
if ndims(z) == 3
    z = rgb2ycbcr(z); % 转换到yCbCr颜色空间
    z = z(:, :, 3); % 提取Y分量
    y = rgb2ycbcr(y); % 对原始载体图像做相同操作
    y = y(:, :, 3);   
end

% 对载体图像进行分块
count = 8; % 每块大小为8*8
[M, N] = size(x);
w = zeros(M, N);
alpha = 0.8; % 水印嵌入强度因子
for i = 1 : M
    for j = 1 : N
        block1 = z((i-1)*count+1 : i*count, (j-1)*count+1 : j*count);
        block0 = y((i-1)*count+1 : i*count, (j-1)*count+1 : j*count);
        block1 = dct2(block1); % 对第count块图像进行DCT变换
        block0 = dct2(block0);
        w(i, j) = (block1(count/2, count/2) - block0(count/2, count/2)) / alpha;
    end
end
w = uint8(w);