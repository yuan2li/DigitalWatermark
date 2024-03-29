function z = file_extract(x, y)
% file_extract 文件格式法提取水印模块
% x为以二进制形式读取的加密后的水印序列
% y为以二进制形式读取的已嵌入水印的载体图像数据序列
% z为提取出的二进制形式的水印序列

len = numel(x); % 将要提取的水印序列长度
z = zeros(len, 1);
% 图像色深，即表示每个像素所用的位数
biBitCount = double(bitshift(y(30), 8) + y(29));
if len <= 2^biBitCount
    % 在调色板补足位顺序提取len字节水印序列
    i = 0;
    j = 54;
    while i <= len
        i = i + 1;
        j = j + 4;
        z(i) = y(j);
    end
else
    % 在调色板补足位顺序提取2^biBitCount字节水印序列
    i = 0;
    j = 54;
    while i <= 2^biBitCount
        i = i + 1;
        j = j + 4;
        z(i) = y(j);
    end
    % 在调色板后顺序提取其它len - 2^biBitCount字节水印序列
    dataBeg = 55 + 2^biBitCount * 4;
    dataEnd = dataBeg + len - 2^biBitCount - 1;
    z(2^biBitCount + 1 : len) = y(dataBeg : dataEnd);
end

z = uint8(z);