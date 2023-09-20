library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity UART_RX is
  port (
    CLK: in std_logic;
    RST: in std_logic;
    DIN: in std_logic;
    DOUT: out std_logic_vector (7 downto 0);
    DOUT_VLD: out std_logic
  );
end entity;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx_fsm is
  port (
    clk : in std_logic;
    rst : in std_logic;
    din : in std_logic;
    ctr_8 : in std_logic;
    ctr_16 : in std_logic;
    ctr_8_en : out std_logic;
    ctr_8_rst : out std_logic;
    ctr_16_en : out std_logic;
    shift_en : out std_logic;
    vld : out std_logic);
end entity uart_rx_fsm;

architecture rtl of uart_rx_fsm is
  signal curr_state : std_logic_vector (1 downto 0);
  signal next_state : std_logic_vector (1 downto 0);
  signal n67_o : std_logic;
  signal n69_o : std_logic_vector (1 downto 0);
  signal n72_q : std_logic_vector (1 downto 0) := "00";
  signal n74_o : std_logic;
  signal n76_o : std_logic_vector (1 downto 0);
  signal n78_o : std_logic;
  signal n80_o : std_logic_vector (1 downto 0);
  signal n82_o : std_logic;
  signal n84_o : std_logic_vector (1 downto 0);
  signal n86_o : std_logic;
  signal n88_o : std_logic_vector (1 downto 0);
  signal n90_o : std_logic;
  signal n91_o : std_logic_vector (3 downto 0);
  signal n93_o : std_logic_vector (1 downto 0);
  signal n97_o : std_logic;
  signal n99_o : std_logic;
  signal n100_o : std_logic_vector (1 downto 0);
  signal n104_o : std_logic;
  signal n108_o : std_logic;
  signal n112_o : std_logic;
  signal n117_o : std_logic;
  signal n120_o : std_logic;
  signal n122_o : std_logic;
  signal n124_o : std_logic;
  signal n126_o : std_logic;
  signal n127_o : std_logic_vector (3 downto 0);
  signal n131_o : std_logic;
  signal n137_o : std_logic;
begin
  ctr_8_en <= n131_o;
  ctr_8_rst <= n137_o;
  ctr_16_en <= n104_o;
  shift_en <= n108_o;
  vld <= n112_o;
  -- work/uart_rx_fsm.vhd:28:12
  curr_state <= n72_q; -- (isignal)
  -- work/uart_rx_fsm.vhd:29:12
  next_state <= n93_o; -- (isignal)
  -- work/uart_rx_fsm.vhd:33:12
  n67_o <= '1' when rising_edge (clk) else '0';
  -- work/uart_rx_fsm.vhd:34:13
  n69_o <= next_state when rst = '0' else "00";
  -- work/uart_rx_fsm.vhd:33:9
  process (clk)
  begin
    if rising_edge (clk) then
      n72_q <= n69_o;
    end if;
  end process;
  -- work/uart_rx_fsm.vhd:47:24
  n74_o <= not din;
  -- work/uart_rx_fsm.vhd:47:17
  n76_o <= curr_state when n74_o = '0' else "01";
  -- work/uart_rx_fsm.vhd:46:13
  n78_o <= '1' when curr_state = "00" else '0';
  -- work/uart_rx_fsm.vhd:52:17
  n80_o <= curr_state when ctr_8 = '0' else "10";
  -- work/uart_rx_fsm.vhd:51:13
  n82_o <= '1' when curr_state = "01" else '0';
  -- work/uart_rx_fsm.vhd:57:17
  n84_o <= curr_state when ctr_8 = '0' else "11";
  -- work/uart_rx_fsm.vhd:56:13
  n86_o <= '1' when curr_state = "10" else '0';
  -- work/uart_rx_fsm.vhd:62:17
  n88_o <= curr_state when ctr_16 = '0' else "00";
  -- work/uart_rx_fsm.vhd:61:13
  n90_o <= '1' when curr_state = "11" else '0';
  n91_o <= n90_o & n86_o & n82_o & n78_o;
  -- work/uart_rx_fsm.vhd:45:9
  with n91_o select n93_o <=
    n88_o when "1000",
    n84_o when "0100",
    n80_o when "0010",
    n76_o when "0001",
    "XX" when others;
  -- work/uart_rx_fsm.vhd:74:13
  n97_o <= '1' when curr_state = "10" else '0';
  -- work/uart_rx_fsm.vhd:77:13
  n99_o <= '1' when curr_state = "11" else '0';
  n100_o <= n99_o & n97_o;
  -- work/uart_rx_fsm.vhd:73:9
  with n100_o select n104_o <=
    '1' when "10",
    '1' when "01",
    '0' when others;
  -- work/uart_rx_fsm.vhd:73:9
  with n100_o select n108_o <=
    '0' when "10",
    '1' when "01",
    '0' when others;
  -- work/uart_rx_fsm.vhd:73:9
  with n100_o select n112_o <=
    '1' when "10",
    '0' when "01",
    '0' when others;
  -- work/uart_rx_fsm.vhd:89:13
  n117_o <= '1' when next_state = "01" else '0';
  -- work/uart_rx_fsm.vhd:92:17
  n120_o <= '0' when ctr_8 = '0' else '1';
  -- work/uart_rx_fsm.vhd:91:13
  n122_o <= '1' when next_state = "10" else '0';
  -- work/uart_rx_fsm.vhd:95:13
  n124_o <= '1' when next_state = "11" else '0';
  -- work/uart_rx_fsm.vhd:97:13
  n126_o <= '1' when next_state = "00" else '0';
  n127_o <= n126_o & n124_o & n122_o & n117_o;
  -- work/uart_rx_fsm.vhd:88:9
  with n127_o select n131_o <=
    '0' when "1000",
    '0' when "0100",
    '0' when "0010",
    '1' when "0001",
    'X' when others;
  -- work/uart_rx_fsm.vhd:88:9
  with n127_o select n137_o <=
    '1' when "1000",
    '1' when "0100",
    n120_o when "0010",
    '0' when "0001",
    'X' when others;
end rtl;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rtl of uart_rx is
  signal wrap_CLK: std_logic;
  signal wrap_RST: std_logic;
  signal wrap_DIN: std_logic;
  subtype typwrap_DOUT is std_logic_vector (7 downto 0);
  signal wrap_DOUT: typwrap_DOUT;
  signal wrap_DOUT_VLD: std_logic;
  signal shift_en : std_logic;
  signal vld : std_logic;
  signal ctr_8 : std_logic;
  signal ctr_8_en : std_logic;
  signal ctr_8_reg : std_logic_vector (3 downto 0);
  signal ctr_8_rst : std_logic;
  signal ctr_15 : std_logic;
  signal ctr_16 : std_logic;
  signal ctr_16_en : std_logic;
  signal ctr_16_reg : std_logic_vector (3 downto 0);
  signal shift_reg : std_logic_vector (7 downto 0);
  signal fsm_ctr_8_en : std_logic;
  signal fsm_ctr_8_rst : std_logic;
  signal fsm_ctr_16_en : std_logic;
  signal fsm_shift_en : std_logic;
  signal fsm_vld : std_logic;
  signal n12_o : std_logic;
  signal n13_o : std_logic;
  signal n17_o : std_logic;
  signal n18_o : std_logic;
  signal n22_o : std_logic;
  signal n23_o : std_logic;
  signal n26_o : std_logic;
  signal n27_o : std_logic;
  signal n30_o : std_logic;
  signal n31_o : std_logic;
  signal n33_o : std_logic_vector (6 downto 0);
  signal n34_o : std_logic_vector (7 downto 0);
  signal n37_o : std_logic_vector (7 downto 0);
  signal n38_q : std_logic_vector (7 downto 0) := "00000000";
  signal n40_o : std_logic;
  signal n41_o : std_logic;
  signal n43_o : std_logic_vector (3 downto 0);
  signal n44_o : std_logic_vector (3 downto 0);
  signal n46_o : std_logic_vector (3 downto 0);
  signal n49_q : std_logic_vector (3 downto 0) := "0000";
  signal n51_o : std_logic;
  signal n54_o : std_logic_vector (3 downto 0);
  signal n57_o : std_logic_vector (3 downto 0);
  signal n58_q : std_logic_vector (3 downto 0) := "0000";
begin
  wrap_clk <= clk;
  wrap_rst <= rst;
  wrap_din <= din;
  dout <= wrap_dout;
  dout_vld <= wrap_dout_vld;
  wrap_DOUT <= shift_reg;
  wrap_DOUT_VLD <= n27_o;
  -- work/uart_rx.vhd:26:12
  shift_en <= fsm_shift_en; -- (signal)
  -- work/uart_rx.vhd:27:12
  vld <= fsm_vld; -- (signal)
  -- work/uart_rx.vhd:29:12
  ctr_8 <= n13_o; -- (signal)
  -- work/uart_rx.vhd:30:12
  ctr_8_en <= fsm_ctr_8_en; -- (signal)
  -- work/uart_rx.vhd:31:12
  ctr_8_reg <= n49_q; -- (isignal)
  -- work/uart_rx.vhd:32:12
  ctr_8_rst <= fsm_ctr_8_rst; -- (signal)
  -- work/uart_rx.vhd:34:12
  ctr_15 <= n18_o; -- (signal)
  -- work/uart_rx.vhd:35:12
  ctr_16 <= n23_o; -- (signal)
  -- work/uart_rx.vhd:36:12
  ctr_16_en <= fsm_ctr_16_en; -- (signal)
  -- work/uart_rx.vhd:37:12
  ctr_16_reg <= n58_q; -- (isignal)
  -- work/uart_rx.vhd:39:12
  shift_reg <= n38_q; -- (isignal)
  -- work/uart_rx.vhd:43:5
  fsm : entity work.uart_rx_fsm port map (
    clk => wrap_CLK,
    rst => wrap_RST,
    din => wrap_DIN,
    ctr_8 => ctr_8,
    ctr_16 => ctr_16,
    ctr_8_en => fsm_ctr_8_en,
    ctr_8_rst => fsm_ctr_8_rst,
    ctr_16_en => fsm_ctr_16_en,
    shift_en => fsm_shift_en,
    vld => fsm_vld);
  -- work/uart_rx.vhd:60:33
  n12_o <= '1' when ctr_8_reg = "1000" else '0';
  -- work/uart_rx.vhd:60:18
  n13_o <= '0' when n12_o = '0' else '1';
  -- work/uart_rx.vhd:61:35
  n17_o <= '1' when ctr_16_reg = "1110" else '0';
  -- work/uart_rx.vhd:61:19
  n18_o <= '0' when n17_o = '0' else '1';
  -- work/uart_rx.vhd:62:35
  n22_o <= '1' when ctr_16_reg = "1111" else '0';
  -- work/uart_rx.vhd:62:19
  n23_o <= '0' when n22_o = '0' else '1';
  -- work/uart_rx.vhd:63:36
  n26_o <= vld and ctr_16;
  -- work/uart_rx.vhd:63:21
  n27_o <= '0' when n26_o = '0' else '1';
  -- work/uart_rx.vhd:67:12
  n30_o <= '1' when rising_edge (wrap_CLK) else '0';
  -- work/uart_rx.vhd:67:29
  n31_o <= shift_en and ctr_15;
  -- work/uart_rx.vhd:68:41
  n33_o <= shift_reg (7 downto 1);
  -- work/uart_rx.vhd:68:30
  n34_o <= wrap_DIN & n33_o;
  -- work/uart_rx.vhd:67:29
  n37_o <= shift_reg when n31_o = '0' else n34_o;
  -- work/uart_rx.vhd:67:9
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n38_q <= n37_o;
    end if;
  end process;
  -- work/uart_rx.vhd:75:12
  n40_o <= '1' when rising_edge (wrap_CLK) else '0';
  -- work/uart_rx.vhd:78:34
  n41_o <= ctr_8_en or ctr_16;
  -- work/uart_rx.vhd:79:40
  n43_o <= std_logic_vector (unsigned (ctr_8_reg) + unsigned'("0001"));
  -- work/uart_rx.vhd:78:13
  n44_o <= ctr_8_reg when n41_o = '0' else n43_o;
  -- work/uart_rx.vhd:76:13
  n46_o <= n44_o when ctr_8_rst = '0' else "0000";
  -- work/uart_rx.vhd:75:9
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n49_q <= n46_o;
    end if;
  end process;
  -- work/uart_rx.vhd:86:12
  n51_o <= '1' when rising_edge (wrap_CLK) else '0';
  -- work/uart_rx.vhd:87:38
  n54_o <= std_logic_vector (unsigned (ctr_16_reg) + unsigned'("0001"));
  -- work/uart_rx.vhd:36:12
  n57_o <= ctr_16_reg when ctr_16_en = '0' else n54_o;
  -- work/uart_rx.vhd:86:9
  process (wrap_CLK)
  begin
    if rising_edge (wrap_CLK) then
      n58_q <= n57_o;
    end if;
  end process;
end rtl;
