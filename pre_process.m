function y = pre_process(x)
% pre_process 水印预处理模块，对原始水印图像加密
% x为原始水印序列
% y为经过预处理加密后的水印序列

% 图像列数与行数是否相同
% [row, col] = size(x);
% if row > col
%     x = padarray(x, [0, row-col], 'post'); % 向右扩展成方阵
% elseif row < col
%     x = padarray(x, [col-row, 0], 'post'); % 向下扩展成方阵
% end

% 进行Arnold变换, 置乱图像矩阵中的像素点
[m, n] = size(x);
y = zeros(m, n);
N = n; % 水印图像数据所组成的数组的维数
t = 5; % Arnold变换的迭代次数
for w = 1 : t
    for u = 1 : m
        for v = 1 : n
            tem = [1, 1; 1, 2] * [u; v];
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