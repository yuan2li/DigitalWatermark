function z = wr_calculate(x, y)
% wr_calculate 计算数据误码率
% x, y为进行匹配比对的两个水印序列
% z为匹配误码率

n = numel(x);
count = 0; % 序列匹配次数
for i = 1 : n
    x_bin = dec2bin(x(i), 8); 
    y_bin = dec2bin(y(i), 8);
    for j = 1 : 8
        if x_bin(j) == y_bin(j)
            count = count + 1;
        end
    end
end
z = vpa((8 * n - count) / count, 3);