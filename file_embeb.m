function z = file_embeb(x, y)
% file_embed 文件格式法嵌入水印模块
% x为加密后的水印序列
% y为原始载体图像的数据
% z为嵌入一重水印的载体图像数据


% 求水印序列长度
len = numel(x);
bfSize = double(bitshift(y(6), 24) + bitshift(y(5), 16) + bitshift(y(4), 8) + y(3));
% 通过图像色深判断图像类型
biBitCount = double(bitshift(y(30), 8) + y(29));
if biBitCount == 1 || biBitCount == 4 || biBitCount == 8 || biBitCount == 16 % 调色板图像
    if len <= 2^biBitCount
        % 在调色板的补足位顺序添加len字节水印序列
        i = 1;
        j = 58;
        z = y;
        while i <= len
            z(j) = x(i); % 补足位为每4个字节的最后一个
            i = i + 1;
            j = j + 4;
        end
    else
        bfSize = bfSize + len - 2^biBitCount; % 确定嵌入水印后的图像文件大小
        z = zeros(bfSize, 1);
        colorEnd = 54 + 2^biBitCount * 4; % 调色板结束位置
        z(1 : colorEnd) = y(1 : colorEnd);
        i = 1;
        j = 58; % 补足位为每4个字节的最后一个
        % 在调色板的补足位顺序添加2^biBitCount字节水印序列
        while i <= 2^biBitCount
            z(j) = x(i);
            i = i + 1;
            j = j + 4;
        end
        % 在调色板和图像数据之间顺序添加剩余len-2^bitBitCount字节水印序列
        dataBeg = colorEnd + 1;
        dataEnd = dataBeg + len - 2^biBitCount - 1;
        z(dataBeg : dataEnd) = x(2^biBitCount + 1 : len);
        z(dataEnd + 1 : bfSize) = y(dataBeg : numel(y));
        % 修改文件头的关键值
        for i = 3 : 6 % 修改文件大小
            z(i) = bitshift(bfSize, -8*(i-3));
            z(i) = bitand(z(i), 255);
        end
         % 修改图像数据的起始地址
        bfOffBits = bitshift(y(14), 24) + bitshift(y(13), 16) + bitshift(y(12), 8) + y(11);
        bfOffBits = bfOffBits + len - 2^biBitCount;
        for i = 11 : 14
            z(i) = bitshift(bfOffBits, -8*(i-11));
            z(i) = bitand(z(i), 255);
        end
    end
elseif biBitCount == 24 || biBitCount == 32 % 真彩色图像
    bfSize = bfSize + len;
    z = zeros(bfSize, 1);
    z(1 : 54) = y(1 : 54);
    % 在调色板和图像数据之间顺序添加len位水印序列
    dataBeg = 55;
    dataEnd = dataBeg + len - 1;
    z(dataBeg : dataEnd) = x(1 : len);
    z(dataEnd + 1, bfSize) = y(dataBeg : numel(y));
    % 修改文件头的关键值
    for i = 3 : 6
        z(i) = bitshift(bfSize, -8*(i-3));
        z(i) = bitand(z(i), 255);
    end
    bfOffBits = bitshift(y(14), 24) + bitshift(y(13), 16) + bitshift(y(12), 8) + y(11);
    bfOffBits = bfOffBits + len;
    for i = 11 : 14
        z(i) = bitshift(bfOffBits, -8*(i-11));
        z(i) = bitand(z(i), 255);
    end
end
z = uint8(z);