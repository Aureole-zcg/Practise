-- 导入IEEE库，这是使用VHDL标准逻辑和算术运算所必需的。
library ieee;
use ieee.std_logic_1164.all; -- 导入标准逻辑位和矢量类型
use ieee.std_logic_unsigned.all; -- 导入无符号数的标准逻辑矢量类型（已弃用，推荐使用numeric_std）
use ieee.std_logic_arith.all; -- 导入算术运算支持（已弃用，推荐使用numeric_std）

-- 定义一个名为any_odd的实体，它是一个时钟分频器，用于生成奇数分频的输出时钟信号。
entity any_odd is
port(
    clk_in : in std_logic; -- 输入时钟信号
    clk_out : out std_logic -- 输出时钟信号，经过处理后的时钟
);
end entity any_odd;

architecture div2 of any_odd is
signal cout1, cout2 : integer range 0 to 8; -- 内部计数器信号，范围为0到8，用于两个独立的分频过程
signal clk1, clk2 : std_logic; -- 中间时钟信号，分别由两个分频过程产生

begin
-- 第一个分频进程，针对clk_in的上升沿触发
process(clk_in)
begin
    if clk_in'event and clk_in = '1' then -- 在clk_in的上升沿触发
        if cout1 < 8 then -- 如果cout1还没有达到最大值8
            cout1 <= cout1 + 1; -- 计数器加1
        else
            cout1 <= 0; -- 如果达到最大值，则重置为0
        end if;

        if cout1 < 8 / 2 then -- 如果cout1小于一半的最大值（即4）
            clk1 <= '1'; -- 设置clk1为高电平
        else
            clk1 <= '0'; -- 否则设置clk1为低电平
        end if;
    end if;
end process;

-- 第二个分频进程，针对clk_in的下降沿触发
process(clk_in)
begin
    if clk_in'event and clk_in = '0' then -- 在clk_in的下降沿触发
        if cout2 < 8 then -- 如果cout2还没有达到最大值8
            cout2 <= cout2 + 1; -- 计数器加1
        else
            cout2 <= 0; -- 如果达到最大值，则重置为0
        end if;

        if cout2 < 8 / 2 then -- 如果cout2小于一半的最大值（即4）
            clk2 <= '1'; -- 设置clk2为高电平
        else
            clk2 <= '0'; -- 否则设置clk2为低电平
        end if;
    end if;
end process;

-- 将两个中间时钟信号进行逻辑或操作，以生成最终的输出时钟信号clk_out
clk_out <= clk1 or clk2;

end architecture div2;
