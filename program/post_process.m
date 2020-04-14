function y = post_process(x)
% post_process 水印后处理模块，对提取出的水印图像解密
% x为提取出的水印序列
% y为经过后处理解密后的水印序列

% 进行Arnold反变换
n = size(x, 1); % 水印图像数据所组成的数组的维数
y = zeros(n);
t = 5; % Arnold反变换的迭代次数（与正变换次数保持一致）
for w = 1 : t
    for u = 1 : n
        for v = 1 : n
            ten = [2, -1; -1, 1] * [u; v];
            u1 = mod(ten(1), n);
            if u1 == 0
                u1 = n;
            end
            v1 = mod(ten(2), n);
            if v1 == 0
                v1 = n;
            end
            y(u1, v1) = x(u, v);
        end
    end
    x = y;
end

% 判断图像是否进行过扩充，以去除扩充像素值
s = all(y == 0, 1); % 返回全零列信息，判断是否进行过列扩充
j = 0;
for i = 1 : n
    if s(i) == 1, break, end
    j = i;
end
if j ~= i
    y(:, i:n) = []; % 删除扩充列
end
[row, col] = size(y);
if row == col
    s = all(y == 0, 2); % 返回全零行信息，判断是否进行过行扩充
    for i = 1 : n
        if s(i) == 1, break, end
        j = i;
    end
    if j ~= i
        y(i:n, :) = []; % 删除扩充行
    end
end

y = uint8(y);