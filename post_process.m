function y = post_process(x)
% post_process 水印后处理模块，对提取出的水印图像解密
% x为提取出的水印序列
% y为经过后处理解密后的水印序列

% 判断图像是否进行过扩充（待解决...）
% 进行Arnold反变换
[m, n] = size(x);
y = zeros(m, n);
N = n; % 水印图像数据所组成的数组的维数
t = 5; % Arnold反变换的迭代次数
for w = 1 : t
    for u = 1 : m
        for v = 1 : n
            tem = [2, -1; -1, 1] * [u; v];
            u1 = mod(tem(1), N);
            if u1 == 0
                u1 = N;
            end
            v1 = mod(tem(2), N);
            if v1 == 0
                v1 = N;
            end
            y(u1, v1) = x(u, v);
        end
    end
    x = y;
end
y = uint8(y);