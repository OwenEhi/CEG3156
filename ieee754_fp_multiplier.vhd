----------------------------------------------------------------------------------
-- Company: Drexel University
-- Engineer: Rob Taglang
-- 
-- Module Name: ieee754_fp_multiplier - Structural
-- Description: Multiplies two IEEE-754 floating point numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ieee754_fp_multiplier is
    port(
        x : in std_logic_vector(31 downto 0);
        y : in std_logic_vector(31 downto 0);
        z : out std_logic_vector(31 downto 0)
    );
end ieee754_fp_multiplier;

architecture Structural of ieee754_fp_multiplier is
    signal x_sign, y_sign, z_sign : std_logic;
    signal x_exponent, y_exponent, z_exponent : std_logic_vector(7 downto 0);
    signal x_mantissa, y_mantissa : std_logic_vector(23 downto 0);
    signal z_mantissa : std_logic_vector(22 downto 0);
begin
    x_sign <= x(31);
    y_sign <= y(31);
    z(31) <= z_sign;
    -- output sign is negative if only one input is negative
    z_sign <= x_sign xor y_sign;
    
    x_mantissa(23) <= '1';
    x_mantissa(22 downto 0) <= x(22 downto 0);
    y_mantissa(23) <= '1';
    y_mantissa(22 downto 0) <= y(22 downto 0);
    z(22 downto 0) <= z_mantissa;
    
    x_exponent <= x(30 downto 23);
    y_exponent <= y(30 downto 23);
    z(30 downto 23) <= z_exponent;
    
    process(x_exponent, y_exponent, x_mantissa, y_mantissa)
        variable add, msb : integer;
        variable multiply, shift_multiply : unsigned(47 downto 0);
        variable mantissa : unsigned(22 downto 0);
    begin
        if (x_exponent = x"00" and x_mantissa = "100000000000000000000000") or (y_exponent = x"00" and y_mantissa = "100000000000000000000000") then
            z_exponent <= x"00";
            z_mantissa <= "00000000000000000000000";
        else
            -- add the exponents
            add := to_integer(unsigned(x_exponent) + unsigned(y_exponent)) - 127;
            --  multiply the mantissas
            multiply := unsigned(x_mantissa) * unsigned(y_mantissa);
            msb := 0;
            for i in 0 to 47 loop
                if multiply(i) = '1' then
                    msb := i;
                end if;
            end loop;
            shift_multiply := multiply srl msb - 23;
            mantissa := shift_multiply(22 downto 0);
            if mantissa = "11111111111111111111111" then
                z_mantissa <= std_logic_vector(mantissa + 1);
                z_exponent <= std_logic_vector(to_unsigned(add + (msb - 46) + 1, 8));       
            else
                z_mantissa <= std_logic_vector(shift_multiply(22 downto 0));
                z_exponent <= std_logic_vector(to_unsigned(add + (msb - 46), 8));       
            end if;
        end if;
    end process;
end Structural;
