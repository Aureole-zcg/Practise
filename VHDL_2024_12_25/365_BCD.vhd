-- 导入IEEE库，这是使用VHDL标准逻辑和算术运算所必需的。
library ieee;
use ieee.std_logic_1164.all; -- 导入标准逻辑位和矢量类型
use ieee.std_logic_unsigned.all; -- 导入无符号数的标准逻辑矢量类型
use ieee.std_logic_arith.all; -- 导入算术运算支持

-- 定义一个名为cnt365的实体，它是一个12位计数器。
entity cnt365 is
port(
    clk: in std_logic; -- 输入时钟信号
    rst: in std_logic; -- 输入复位信号
    updown: in std_logic; -- 输入上升/下降计数控制信号
    qout: buffer std_logic_vector(11 downto 0) -- 输出12位计数值，buffer表示该值可以在内部修改
);
end cnt365;

architecture behave of cnt365 is
begin
-- 定义一个进程，它在clk、rst或updown信号发生变化时触发。
process(clk, rst, updown)
begin
    -- 如果复位信号rst有效（高电平），则将qout重置为全0。
    if rst = '1' then 
        qout <= (others => '0');
    -- 在时钟clk的上升沿触发操作。
    elsif clk'event and clk = '1' then
        -- 如果updown信号指示上升计数（假设'1'为上升）。
        if updown = '1' then
            -- 如果计数值达到"001101100100"（即十进制364），则重置为0，形成模365计数器。
            if qout = "001101100100" then
                qout <= (others => '0');
            -- 如果低8位等于x"99"（即十进制153），则增加x"67"（十进制103）以处理进位。
            elsif qout(7 downto 0) = x"99" then
                qout <= qout + x"67";
            -- 如果低4位等于x"9"（即十进制9），则增加x"7"（十进制7）以处理进位。
            elsif qout(3 downto 0) = x"9" then
                qout <= qout + x"7";
            -- 否则，正常情况下只是简单地增加1。
            else
                qout <= qout + 1;
            end if;
        -- 如果updown信号指示下降计数（假设'0'为下降）。
        else
            -- 如果计数值为0，则设置为"001101100100"（即十进制364），模拟模365的循环。
            if qout = "000000000000" then
                qout <= "001101100100";
            -- 如果低8位为0，则减少"01100111"（即十进制103）以处理借位。
            elsif qout(7 downto 0) = "00000000" then
                qout <= qout - "01100111";
            -- 如果低4位为0，则减少x"7"（十进制7）以处理借位。
            elsif qout(3 downto 0) = "0000" then
                qout <= qout - x"7";
            -- 否则，正常情况下只是简单地减少1。
            else
                qout <= qout - 1;
            end if;
        end if;
    end if;
end process;
end behave;
