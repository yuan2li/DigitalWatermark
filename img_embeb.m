function z = img_embeb(x, y)
% img_embeb DCT变换域技术嵌入水印模块
% x为加密后的水印序列
% y为嵌入一重水印的载体图像数据
% z为嵌入二重水印的载体图像数据

% 判断载体图像是否为彩色图像
if ndims(y) == 3
    y = rgb2ycbcr(y); % 转换到yCbCr颜色空间
    y = y(:, :, 3); % 提取Y分量
end
% 对载体图像进行分块
count = 8; % 每块大小为8*8
alpha = 0.8; % 水印嵌入强度因子
z = y;
[M, N] = size(x);
for i = 1 : M
    for j = 1 : N
        block = z((i-1)*count+1 : i*count, (j-1)*count+1 : j*count);
        block = dct2(block); % 对第count块图像进行DCT变换
        block(count/2, count/2) = block(count/2, count/2) + alpha * x(i, j); % 在每块DCT系数的(4,5)位置嵌入水印
        block = idct2(block); % 对第count块图像进行DCT逆变换
        z((i-1)*count+1 : i*count, (j-1)*count+1 : j*count) = block;
    end
end
% 判断载体图像是否为彩色图像
if ndims(y) == 3
    z = y;
    z(:, :, 3) = z; % 将图像数据写回Y分量
    z = ycbcr2rgb(z); % 转换到RGB颜色空间
end
z = uint8(z);