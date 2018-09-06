----------------------------------------------------------------------------------
-- Company: University at Buffalo(CSE)
-- Engineer: Siddharth Selvaraj
-- 
-- Create Date: 04/30/2018 10:45:28 PM
-- Design Name: Game
-- Module Name: Game - Behavioral
-- Project Name: Guessing Game
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity game is
 Port ( 
  sw : in STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
  led : out STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
  seg : out STD_LOGIC_VECTOR (6 downto 0);
  an  : out STD_LOGIC_VECTOR (3 downto 0);
  btnD,btnU,btnC,btnL,btnR,clk : in STD_LOGIC );

end game;

architecture Behavioral of game is

signal cond : STD_LOGIC:='0';
signal ref : STD_LOGIC_VECTOR (20 downto 0):=(others=>'0');
signal number_1 : STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
signal number_2 : STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
signal led_act : STD_LOGIC_VECTOR (1 downto 0):=(others=>'0');
signal to_decimal : STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
signal display_temp : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
signal display : STD_LOGIC_VECTOR (6 downto 0):=(others=>'0');
signal N1_digit0 : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
signal N1_digit1 : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
signal N1_digit2 : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
signal N1_digit3 : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
signal N2_digit0 : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
signal N2_digit1 : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
signal N2_digit2 : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
signal N2_digit3 : STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
signal seg_blank : STD_LOGIC_VECTOR (6 downto 0):="1111111"; 
signal seg_P : STD_LOGIC_VECTOR (6 downto 0):="0001100"; 
signal seg_L : STD_LOGIC_VECTOR (6 downto 0):="1000111"; 
signal seg_A : STD_LOGIC_VECTOR (6 downto 0):="0001000"; 
signal seg_Y : STD_LOGIC_VECTOR (6 downto 0):="0010001"; 
signal seg_ONE : STD_LOGIC_VECTOR (6 downto 0):="1111001";
signal seg_TWO : STD_LOGIC_VECTOR (6 downto 0):="0100100";
signal seg_H : STD_LOGIC_VECTOR (6 downto 0):="0001001"; 
signal seg_O : STD_LOGIC_VECTOR (6 downto 0):="1000000"; 
signal n_trys : integer  :=0;
signal stage : integer :=1;
signal blinker : integer :=0;
signal button_Counter : integer := 0;
signal temp : integer :=-1;
signal ones : integer :=-2;
signal tens : integer :=0;
signal hundreds : integer :=0;
signal thousands : integer :=0;

begin
process(clk,ref,temp,number_1,number_2,btnC,ones,tens,hundreds,thousands,to_decimal,cond,button_Counter)
begin
--pressing btnC
if (rising_edge(clk)) then
led <= sw;
button_Counter <= 0;
if (BtnC ='1') then 
    button_Counter <= button_Counter + 1;
end if;

--led blinking
if (UNSIGNED(number_2) = UNSIGNED(number_1)) and cond ='1' then
   if blinker < 30000000/2 then 
     blinker <= blinker + 1;
     led <= (others=>'1');
   elsif (blinker < 30000000) then
     led <= (others=>'0');
     blinker <= blinker + 1;
   else 
     led <= (others=>'1');
     blinker <= 0;
   end if;
end if;

--decimal conversion
if (button_Counter = 1200000 and cond='0') then
  temp <= temp+1;
  if ones = 9 then
   ones <= 0;
   if tens = 9 then
    tens <= 0;
    if hundreds = 9 then
     hundreds <= 0;
     if thousands = 9 then
      thousands <= 0;
      else
       thousands <= thousands +1;  
     end if;
     else
      hundreds <= hundreds + 1; 
     end if; 
     else
      tens <= tens + 1;
     end if;
    else
     ones <= ones + 1;
   end if;
elsif (button_Counter = 1200000 and cond = '1') then 
temp <= -1;
ones <= -2;
tens <= 0;
hundreds <= 0;
thousands <= 0;
end if;
to_decimal(3 downto 0) <= STD_LOGIC_VECTOR(TO_UNSIGNED(ones,4));
to_decimal(7 downto 4) <= STD_LOGIC_VECTOR(TO_UNSIGNED(tens,4));
to_decimal(11 downto 8) <= STD_LOGIC_VECTOR(TO_UNSIGNED(hundreds,4));
to_decimal(15 downto 12) <= STD_LOGIC_VECTOR(TO_UNSIGNED(thousands,4));

if ref = "111111111111111111111" then
ref <= (others=>'0');
else 
ref <= STD_LOGIC_VECTOR(UNSIGNED(ref)+1);
end if;
end if;
end process;
led_act <= ref(20 downto 19);

--Number Inputs:
process(btnU,btnD,btnL,btnR,N1_digit0,N1_digit1,N1_digit2,N1_digit3,N2_digit0,N2_digit1,N2_digit2,N2_digit3,sw,temp)
begin
if (btnR = '1' and temp=0 ) then 
N1_digit0 <= sw(3 downto 0);
elsif (btnD = '1' and temp=0) then 
N1_digit1 <= sw(3 downto 0);
elsif (btnU = '1' and temp=0) then
N1_digit2 <= sw(3 downto 0);
elsif (btnL = '1' and temp=0) then
N1_digit3 <= sw(3 downto 0);
elsif (btnR = '1' and temp>=1) then
N2_digit0 <= sw(3 downto 0);
elsif (btnD = '1' and temp>=1) then
N2_digit1 <= sw(3 downto 0);
elsif (btnU = '1' and temp>=1) then
N2_digit2 <= sw(3 downto 0);
elsif (btnL = '1' and temp>=1) then
N2_digit3 <= sw(3 downto 0);
end if;
end process;

--game stage switching
process(clk,temp,to_decimal,number_1,number_2,stage,btnC,cond,N1_digit0,N1_digit1,N1_digit2,N1_digit3,N2_digit0,N2_digit1,N2_digit2,N2_digit3)
begin
number_2 <= N2_digit3 & N2_digit2 & N2_digit1 & N2_digit0;
if(temp=-1) then
cond <= '0';
stage <= -1; -- PLAY(default stage)
end if;
if rising_edge(clk) then
if (button_Counter = 1200000) then
  if (temp=-1) then
  stage <= 1; -- Player 1
  elsif (temp=0) then
  number_1 <= N1_digit3 & N1_digit2 & N1_digit1 & N1_digit0;
  stage <= 2; -- Player 2
  elsif(temp>=1 and (UNSIGNED(number_2) > UNSIGNED(number_1))) then    
  stage <= 3; -- 2 HI
  elsif(temp>=1 and (UNSIGNED(number_2) < UNSIGNED(number_1))) then    
  stage <= 4; -- 2 LO
  elsif(temp>=1 and (UNSIGNED(number_2) = UNSIGNED(number_1))) then    
  cond <= '1';
  stage <= 5; -- Trys
  end if;
end if;
end if;
end process;

--seven segment display in each stage of game:
process(clk,sw,stage,led_act,seg_blank,seg_P,seg_L,seg_A,seg_Y,seg_ONE,seg_TWO,seg_H,seg_O,to_decimal,display,blinker)
begin
if stage = -1 then
  case led_act is
  when "00" => 
  an <= "1110";
  seg <= seg_Y;                     
  when "01" => 
  an <= "1101";
  seg <= seg_A;                           
  when "10" => 
  an <= "1011";
  seg <= seg_L;                           
  when "11" => 
  an <= "0111";
  seg <= seg_P;
  end case; 
elsif stage = 1 then
  case led_act is
  when "00" => 
  an <= "1110";
  seg <= seg_ONE;                     
  when "01" => 
  an <= "1101";
  seg <= seg_blank;                           
  when "10" => 
  an <= "1011";
  seg <= seg_L;                           
  when "11" => 
  an <= "0111";
  seg <= seg_P;
  end case; 
elsif stage = 2 then
  case led_act is
  when "00" => 
  an <= "1110";
  seg <= seg_TWO;                     
  when "01" => 
  an <= "1101";
  seg <= seg_blank;                           
  when "10" => 
  an <= "1011";
  seg <= seg_L;                           
  when "11" => 
  an <= "0111";
  seg <= seg_P;
  end case; 
elsif stage = 3 then 
  case led_act is
  when "00" => 
  an <= "1110";
  seg <= seg_ONE;                     
  when "01" => 
  an <= "1101";
  seg <= seg_H;                           
  when "10" => 
  an <= "1011";
  seg <= seg_blank;                           
  when "11" => 
  an <= "0111";
  seg <= seg_TWO;
  end case;
elsif stage = 4 then
  case led_act is
  when "00" => 
  an <= "1110";
  seg <= seg_O;                     
  when "01" => 
  an <= "1101";
  seg <= seg_L;                           
  when "10" => 
  an <= "1011";
  seg <= seg_blank;                           
  when "11" => 
  an <= "0111";
  seg <= seg_TWO;
  end case; 
elsif stage = 5 then
  case led_act is
  when "00" => 
  an <= "1110";
  display_temp <= to_decimal(3 downto 0);
  seg <= display;                   
  when "01" => 
  an <= "1101";
  display_temp <= to_decimal(7 downto 4);
  seg <= display;                           
  when "10" => 
  an <= "1011";
  display_temp <= to_decimal(11 downto 8);
  seg <= display;                           
  when "11" => 
  an <= "0111";
  display_temp <= to_decimal(15 downto 12);
  seg <= display;
  end case;         
end if;
end process;

--BCD
process(display_temp)
begin
case display_temp is
   when "0000" => display <= "1000000";     
   when "0001" => display <= "1111001"; 
   when "0010" => display <= "0100100"; 
   when "0011" => display <= "0110000"; 
   when "0100" => display <= "0011001";
   when "0101" => display <= "0010010"; 
   when "0110" => display <= "0000010"; 
   when "0111" => display <= "1111000"; 
   when "1000" => display <= "0000000";     
   when "1001" => display <= "0010000"; 
   when "1010" => display <= "0100000";
   when "1011" => display <= "0000011";
   when "1100" => display <= "1000110";
   when "1101" => display <= "0100001";
   when "1110" => display <= "0000110";
   when "1111" => display <= "0001110";
   end case;
end process;
end Behavioral;

