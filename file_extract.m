function z = file_extract(x, y)
% file_extract 文件格式法提取水印模块
% x为以二进制形式读取的加密后的水印序列
% y为以二进制形式读取的原始载体图像数据
% z为提取出的水印序列

len = numel(x); % 将要提取的水印序列长度
z = zeros(len, 1);
% 通过图像色深判断图像类型
biBitCount = double(bitshift(y(30), 8) + y(29));
if biBitCount == 1 || biBitCount == 4 || biBitCount == 8 || biBitCount == 16 % 调色板图像
    if len <= 2^biBitCount
        % 在调色板补足位顺序提取len字节水印序列
       i = 1;
       j = 58;
       while i <= len
           z(i) = y(j);
           i = i + 1;
           j = j + 4;
       end
    else
        % 在调色板补足位顺序提取2^biBitCount字节水印序列
        i = 1;
        j = 58;
        while i <= 2^biBitCount
            z(i) = y(j);
            i = i + 1;
            j = j + 4;
        end
        % 在调色板后顺序提取其它len - 2^biBitCount字节水印序列
        dataBeg = 55 + 2^biBitCount * 4;
        dataEnd = dataBeg + len - 2^biBitCount - 1;
        z(2^biBitCount + 1 : len) = y(dataBeg : dataEnd);
    end
elseif biBitCount == 24 || biBitCount == 32 % 真彩色图像
    % 在文件信息头之后顺序提取len字节水印序列
    dataBeg = 55;
    dataEnd = dataBeg + len - 1;
    z(1 : len) = y(dataBeg : dataEnd); 
end
z = uint8(z);