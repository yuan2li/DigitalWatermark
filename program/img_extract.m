function w = img_extract(x, y, z)
% img_extract DCT变换域技术提取水印模块
% x为加密后的水印序列
% y为原始载体图像数据
% z为已嵌入水印的载体图像数据
% w为提取出的水印序列

% 将原始载体图像和已嵌入水印的载体图像的系数矩阵进行分块
count = 8; % 每块大小为8*8
[M, N] = size(x);
w = zeros(M, N);
alpha = 0.8; % 水印嵌入强度因子，决定了频域系数的修改幅度，可调整
for i = 1 : M
    for j = 1 : N
        block1 = z((i-1)*count+1 : i*count, (j-1)*count+1 : j*count);
        block0 = y((i-1)*count+1 : i*count, (j-1)*count+1 : j*count);
        % 对第count块已嵌入水印的载体图像系数矩阵进行DCT变换
        block1 = dct2(block1);
        % 对第count块原始载体图像系数矩阵进行DCT变换
        block0 = dct2(block0);
        % 对比两个系数矩阵，提取出水印序列
        w(i, j) = (block1(count/2, count/2) ...
            - block0(count/2, count/2)) / alpha;
    end
end

w = uint8(w);