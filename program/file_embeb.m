function z = file_embeb(x, y)
% file_embed 文件格式法嵌入水印模块
% x为以二进制形式读取的加密后的水印序列
% y为以二进制形式读取的原始载体图像数据序列
% z为已嵌入水印的载体图像的二进制数据序列

len = numel(x); % 水印序列长度
% bmp图像文件大小（小端模式计算）
bfSize = double(bitshift(y(6), 24) + bitshift(y(5), 16) ...
        + bitshift(y(4), 8) + y(3)); 
% 图像色深，即表示每个像素所用的位数
biBitCount = double(bitshift(y(30), 8) + y(29)); 
if len <= 2^biBitCount
    % 直接在调色板的补足位顺序添加len字节水印序列
    i = 0;
    j = 54; % 文件头（14B）、信息头（40B）结束位置
    z = y;
    while i <= len
        i = i + 1;
        j = j + 4; % 补足位为每4个字节的最后一个
        z(j) = x(i);
    end
else
    % 确定嵌入水印后的图像文件大小
    bfSize = bfSize + len - 2^biBitCount;
    z = zeros(bfSize, 1);
    colorEnd = 54 + 2^biBitCount * 4; % 调色板结束位置
    z(1 : colorEnd) = y(1 : colorEnd);
    i = 0;
    j = 54;
    % 在调色板的补足位顺序添加2^biBitCount字节水印序列
    while i <= 2^biBitCount
        i = i + 1;
        j = j + 4;
        z(j) = x(i);
    end
    % 在调色板和位图数据之间顺序添加剩余len-2^bitBitCount字节水印序列
    dataBeg = colorEnd + 1;
    dataEnd = dataBeg + len - 2^biBitCount - 1;
    z(dataBeg : dataEnd) = x(2^biBitCount + 1 : len);
    z(dataEnd + 1 : bfSize) = y(dataBeg : numel(y));
    % 修改文件头的关键值
    for i = 3 : 6 % 从低字节依此取值修改文件大小值
        z(i) = bitshift(bfSize, -8*(i-3));
        z(i) = bitand(z(i), 255);
    end
    % 修改位图数据的起始地址
    bfOffBits = bitshift(y(14), 24) + bitshift(y(13), 16) ...
        + bitshift(y(12), 8) + y(11);
    bfOffBits = bfOffBits + len - 2^biBitCount;
    for i = 11 : 14
        z(i) = bitshift(bfOffBits, -8*(i-11));
        z(i) = bitand(z(i), 255);
    end
end

z = uint8(z);