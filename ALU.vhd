library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ALU is
    generic(

        nbit:           Integer:=   16;
        exponent_bits:  Integer:=   7;
        mantissa_bits:  Integer:=   8
    );
    port(
        clk:        in  std_logic;
        A:          in  std_logic_vector(nbit-1 downto 0);
        B:          in  std_logic_vector(nbit-1 downto 0);
        output_sel: in  std_logic_vector(2 downto 0);
        logic_sel:  in  std_logic;
        left_sel:   in  std_logic;
        rotate_sel: in  std_logic;
        sub_sel:    in  std_logic;
        O, M, D:          out std_logic_vector(nbit-1 downto 0)
    );
end entity ALU;

architecture structural of ALU is

    signal  sum_diff_out:       std_logic_vector(nbit-1 downto 0);
    component adder is
    end component adder;
    
    signal  mul_out:            std_logic_vector(nbit-1 downto 0);
    component multiplier is
    end component multiplier;
    
    signal  div_out:            std_logic_vector(nbit-1 downto 0);
    component divider is
    end component divider;
    
    signal  shift_out:          std_logic_vector(nbit-1 downto 0);
    component shifter_rotator is
    end component shifter_rotator;
    
    signal  FP_sub_ctrl:        std_logic;
    signal  FP_sum_diff_out:    std_logic_vector(nbit-1 downto 0);
    component FP_adder_subtractor is
        generic(
            -- Lab 1 floating point standard.
            nbit:       natural:=   16;
            exponent:   natural:=   7;
            mantissa:   natural:=   8
        );
        port(
            clk:    in          std_logic;
            A:      in          std_logic_vector(nbit-1 downto 0);
            B:      in          std_logic_vector(nbit-1 downto 0);
            sub:    in          std_logic;
            S, M, D:      out         std_logic_vector(nbit-1 downto 0)
        );
    end component FP_adder_subtractor;
    
    signal  FP_mul_out:         std_logic_vector(nbit-1 downto 0);
    component FP_multiplier is
        generic(
            -- Lab 1 floating point standard.
            nbit:       natural:=   16;
            exponent:   natural:=   7;
            mantissa:   natural:=   8
        );
        port(
            clk:    in          std_logic;
            A:      in          std_logic_vector(nbit-1 downto 0);
            B:      in          std_logic_vector(nbit-1 downto 0);
            S, M, D:      out         std_logic_vector(nbit-1 downto 0)
        );
    end component FP_multiplier;
    
    signal  FP_div_out:         std_logic_vector(nbit-1 downto 0);
    component FP_divider is
        generic(
            -- Lab 1 floating point standard.
            nbit:       natural:=   16;
            exponent:   natural:=   7;
            mantissa:   natural:=   8
        );
        port(
            clk:    in          std_logic;
            A:      in          std_logic_vector(nbit-1 downto 0);
            B:      in          std_logic_vector(nbit-1 downto 0);
            S, M, D:      out         std_logic_vector(nbit-1 downto 0)
        );
    end component FP_divider;
    
begin

    --ADDER:  adder port map();
        
    --MULTIPLIER: multiplier port map();
    
    --DIVIDER:    divider port map();
        
    --SH_ROT: shifter_rotator port map();
    
    
    --FP_sub_ctrl <=  '1' when sub_sel = '1'
                    --'0';
    adder1: FP_adder_subtractor
        generic map(
            nbit        =>  nbit,
            exponent    =>  exponent_bits,
            mantissa    =>  mantissa_bits
        )
        port map(
            clk =>  clk,
            A   =>  A,
            B   =>  B,
            sub =>  FP_sub_ctrl,
            S   =>  FP_sum_diff_out
        );
    
    multiplier1:  FP_multiplier
        generic map(
            nbit        =>  nbit,
            exponent    =>  exponent_bits,
            mantissa    =>  mantissa_bits
        )
        port map(
            clk =>  clk,
            A   =>  A,
            B   =>  B,
            M   =>  FP_mul_out
        );
    
    divider1: FP_divider
        generic map(
            nbit        =>  nbit,
            exponent    =>  exponent_bits,
            mantissa    =>  mantissa_bits
        )
        port map(
            clk =>  clk,
            A   =>  A,
            B   =>  B,
            D   =>  FP_div_out
        );
    
    O   <=  sum_diff_out when output_sel = "000" else
            mul_out when output_sel = "001" else
            div_out when output_sel = "010" else
            shift_out when output_sel = "011" else
            FP_sum_diff_out when output_sel = "100" else
            FP_mul_out when output_sel = "101" else
            FP_div_out when output_sel = "110" else
            (others => '0');

end architecture structural;
