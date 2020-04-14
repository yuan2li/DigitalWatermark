function z = img_embeb(x, y)
% img_embeb DCT变换域技术嵌入水印模块
% x为加密后的水印序列
% y为原始载体图像数据
% z为已嵌入水印的载体图像数据

% 将原始载体图像系数矩阵进行分块
count = 8; % 每块大小为8*8
alpha = 0.8; % 水印嵌入强度因子，决定了频域系数的修改幅度，可调整
z = y;
[M, N] = size(x);
for i = 1 : M
    for j = 1 : N
        block = z((i-1)*count+1 : i*count, (j-1)*count+1 : j*count);
        block = dct2(block); % 对第count块图像系数矩阵进行DCT变换
        % 在每块DCT系数矩阵的中频位置嵌入水印
        block(count/2, count/2) = block(count/2, count/2) + alpha*x(i, j);
        block = idct2(block); % 对第count块图像系数矩阵进行DCT逆变换
        z((i-1)*count+1 : i*count, (j-1)*count+1 : j*count) = block;
    end
end