/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06-SP1
// Date      : Mon Nov 25 18:28:32 2019
/////////////////////////////////////////////////////////////


module protocol ( clk, n_rst, rx_packet, buffer_reserved, tx_packet_data_size, 
        buffer_occupancy, tx_busy, d_mode, tx_packet, clear, tx_error, 
        tx_transfer_active, rx_error, rx_transfer_active, rx_data_ready );
  input [3:0] rx_packet;
  input [6:0] tx_packet_data_size;
  input [6:0] buffer_occupancy;
  output [1:0] tx_packet;
  input clk, n_rst, buffer_reserved, tx_busy;
  output d_mode, clear, tx_error, tx_transfer_active, rx_error,
         rx_transfer_active, rx_data_ready;
  wire   N146, N147, N148, N149, N150, N152, N155, N156, N157, N158, N159,
         N160, N161, N162, n132, n136, n137, n138, n139, n140, n141, n142,
         n143, n144, n145, n146, n147, n148, n149, n150, n151, n152, n153,
         n154, n155, n156, n157, n158, n159, n160, n161, n162, n163, n164,
         n165, n166, n167, n168, n169, n170, n171, n172, n173, n174, n175,
         n176, n177, n178, n179, n180, n181, n182, n183, n184, n185, n186,
         n187, n188, n189, n190, n191, n192, n193, n194, n195, n196, n197,
         n198, n199, n200, n201, n202, n203, n204, n205, n206, n207, n208,
         n209, n210, n211, n212, n213, n214, n215, n216, n217, n218, n219,
         n220, n221, n222, n223, n224, n225, n226, n227, n228, n229, n230,
         n231, n232, n233, n234, n235, n236, n237, n238, n239, n240, n241;
  wire   [4:0] state;

  DFFSR \state_reg[0]  ( .D(n236), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[0]) );
  DFFSR \state_reg[3]  ( .D(n132), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[3]) );
  DFFSR \state_reg[1]  ( .D(n237), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[1]) );
  DFFSR \state_reg[2]  ( .D(n238), .CLK(clk), .R(n_rst), .S(1'b1), .Q(state[2]) );
  LATCH \tx_packet_reg[1]  ( .CLK(N160), .D(N162), .Q(tx_packet[1]) );
  LATCH \tx_packet_reg[0]  ( .CLK(N160), .D(N161), .Q(tx_packet[0]) );
  LATCH d_mode_reg ( .CLK(N146), .D(N147), .Q(d_mode) );
  LATCH clear_reg ( .CLK(N148), .D(N149), .Q(clear) );
  LATCH rx_data_ready_reg ( .CLK(N150), .D(n241), .Q(rx_data_ready) );
  LATCH rx_transfer_active_reg ( .CLK(N152), .D(n240), .Q(rx_transfer_active)
         );
  LATCH rx_error_reg ( .CLK(n239), .D(N155), .Q(rx_error) );
  LATCH tx_transfer_active_reg ( .CLK(N156), .D(N157), .Q(tx_transfer_active)
         );
  LATCH tx_error_reg ( .CLK(N158), .D(N159), .Q(tx_error) );
  NAND3X1 U151 ( .A(n136), .B(n137), .C(n138), .Y(n236) );
  NOR2X1 U152 ( .A(n139), .B(n140), .Y(n138) );
  OAI22X1 U153 ( .A(n141), .B(n142), .C(n143), .D(n144), .Y(n140) );
  OAI21X1 U154 ( .A(n145), .B(n146), .C(n147), .Y(n139) );
  OAI21X1 U155 ( .A(n148), .B(n149), .C(n150), .Y(n147) );
  AOI21X1 U156 ( .A(n151), .B(state[0]), .C(n152), .Y(n136) );
  NAND3X1 U157 ( .A(n153), .B(n137), .C(n154), .Y(n237) );
  AOI21X1 U158 ( .A(n155), .B(n150), .C(n156), .Y(n154) );
  NAND2X1 U159 ( .A(n157), .B(n158), .Y(n156) );
  NOR2X1 U160 ( .A(n148), .B(n149), .Y(n155) );
  NOR3X1 U161 ( .A(N155), .B(N159), .C(n159), .Y(n137) );
  OAI22X1 U162 ( .A(n143), .B(n160), .C(n161), .D(n162), .Y(n159) );
  NAND3X1 U163 ( .A(rx_packet[3]), .B(rx_packet[2]), .C(n163), .Y(n143) );
  NOR2X1 U164 ( .A(n164), .B(n148), .Y(n163) );
  INVX1 U165 ( .A(rx_packet[1]), .Y(n148) );
  AOI22X1 U166 ( .A(n165), .B(n166), .C(n167), .D(n142), .Y(n153) );
  NAND3X1 U167 ( .A(n168), .B(n169), .C(n170), .Y(n238) );
  NOR2X1 U168 ( .A(n171), .B(n172), .Y(n170) );
  OAI22X1 U169 ( .A(n141), .B(n142), .C(n173), .D(n161), .Y(n172) );
  INVX1 U170 ( .A(tx_busy), .Y(n161) );
  NAND3X1 U171 ( .A(rx_packet[3]), .B(rx_packet[2]), .C(n174), .Y(n142) );
  NOR2X1 U172 ( .A(rx_packet[1]), .B(rx_packet[0]), .Y(n174) );
  OAI21X1 U173 ( .A(rx_packet[3]), .B(n175), .C(n176), .Y(n169) );
  AND2X1 U174 ( .A(n158), .B(n157), .Y(n168) );
  INVX1 U175 ( .A(n177), .Y(n239) );
  INVX1 U176 ( .A(n178), .Y(n241) );
  NAND3X1 U177 ( .A(n179), .B(n180), .C(n181), .Y(n132) );
  AOI21X1 U178 ( .A(n182), .B(n145), .C(n183), .Y(n181) );
  NAND2X1 U179 ( .A(n157), .B(n144), .Y(n183) );
  INVX1 U180 ( .A(n151), .Y(n157) );
  NOR2X1 U181 ( .A(n184), .B(n185), .Y(n151) );
  NAND3X1 U182 ( .A(n158), .B(n186), .C(n173), .Y(n185) );
  AND2X1 U183 ( .A(n187), .B(n162), .Y(n173) );
  NAND2X1 U184 ( .A(n188), .B(state[2]), .Y(n162) );
  NAND3X1 U185 ( .A(state[0]), .B(state[2]), .C(n189), .Y(n158) );
  NAND3X1 U186 ( .A(n190), .B(n191), .C(n144), .Y(n184) );
  INVX1 U187 ( .A(N152), .Y(n190) );
  OR2X1 U188 ( .A(n192), .B(n193), .Y(n145) );
  NAND3X1 U189 ( .A(n194), .B(n195), .C(n196), .Y(n193) );
  NOR2X1 U190 ( .A(buffer_occupancy[3]), .B(buffer_occupancy[2]), .Y(n196) );
  NAND3X1 U191 ( .A(n197), .B(n198), .C(n199), .Y(n192) );
  NOR2X1 U192 ( .A(buffer_reserved), .B(buffer_occupancy[6]), .Y(n199) );
  INVX1 U193 ( .A(n146), .Y(n182) );
  NAND3X1 U194 ( .A(n200), .B(n201), .C(n166), .Y(n146) );
  INVX1 U195 ( .A(rx_packet[3]), .Y(n201) );
  INVX1 U196 ( .A(n152), .Y(n180) );
  OAI21X1 U197 ( .A(n202), .B(n186), .C(n203), .Y(n152) );
  AOI21X1 U198 ( .A(n204), .B(n205), .C(n206), .Y(n203) );
  INVX1 U199 ( .A(n207), .Y(n206) );
  NOR2X1 U200 ( .A(n208), .B(n209), .Y(n205) );
  NAND3X1 U201 ( .A(n210), .B(n166), .C(n211), .Y(n209) );
  XOR2X1 U202 ( .A(n195), .B(tx_packet_data_size[1]), .Y(n211) );
  INVX1 U203 ( .A(buffer_occupancy[1]), .Y(n195) );
  XOR2X1 U204 ( .A(n194), .B(tx_packet_data_size[0]), .Y(n210) );
  INVX1 U205 ( .A(buffer_occupancy[0]), .Y(n194) );
  NAND3X1 U206 ( .A(rx_packet[3]), .B(n212), .C(n200), .Y(n208) );
  INVX1 U207 ( .A(buffer_reserved), .Y(n212) );
  NOR2X1 U208 ( .A(n213), .B(n214), .Y(n204) );
  NAND2X1 U209 ( .A(n215), .B(n216), .Y(n214) );
  XOR2X1 U210 ( .A(n198), .B(tx_packet_data_size[5]), .Y(n216) );
  INVX1 U211 ( .A(buffer_occupancy[5]), .Y(n198) );
  XNOR2X1 U212 ( .A(buffer_occupancy[6]), .B(tx_packet_data_size[6]), .Y(n215)
         );
  NAND3X1 U213 ( .A(n217), .B(n218), .C(n219), .Y(n213) );
  XOR2X1 U214 ( .A(n197), .B(tx_packet_data_size[4]), .Y(n219) );
  INVX1 U215 ( .A(buffer_occupancy[4]), .Y(n197) );
  XNOR2X1 U216 ( .A(buffer_occupancy[2]), .B(tx_packet_data_size[2]), .Y(n218)
         );
  XNOR2X1 U217 ( .A(buffer_occupancy[3]), .B(tx_packet_data_size[3]), .Y(n217)
         );
  INVX1 U218 ( .A(n175), .Y(n202) );
  NAND3X1 U219 ( .A(n164), .B(n220), .C(rx_packet[1]), .Y(n175) );
  INVX1 U220 ( .A(rx_packet[0]), .Y(n164) );
  AOI22X1 U221 ( .A(n165), .B(n166), .C(n176), .D(rx_packet[3]), .Y(n179) );
  INVX1 U222 ( .A(n186), .Y(n176) );
  AND2X1 U223 ( .A(n200), .B(rx_packet[3]), .Y(n165) );
  NOR2X1 U224 ( .A(n149), .B(rx_packet[1]), .Y(n200) );
  NAND2X1 U225 ( .A(rx_packet[0]), .B(n220), .Y(n149) );
  INVX1 U226 ( .A(rx_packet[2]), .Y(n220) );
  NAND3X1 U227 ( .A(n207), .B(n221), .C(n222), .Y(N162) );
  NAND2X1 U228 ( .A(n223), .B(n177), .Y(N161) );
  NOR2X1 U229 ( .A(n166), .B(N155), .Y(n177) );
  INVX1 U230 ( .A(n222), .Y(n166) );
  OR2X1 U231 ( .A(N150), .B(N157), .Y(N160) );
  NAND2X1 U232 ( .A(n222), .B(n191), .Y(N156) );
  NAND2X1 U233 ( .A(n224), .B(n225), .Y(N155) );
  NAND3X1 U234 ( .A(n178), .B(n141), .C(n222), .Y(N152) );
  NAND3X1 U235 ( .A(n222), .B(n178), .C(n225), .Y(N150) );
  OR2X1 U236 ( .A(N149), .B(n240), .Y(N148) );
  INVX1 U237 ( .A(n141), .Y(n240) );
  NOR2X1 U238 ( .A(n167), .B(n150), .Y(n141) );
  AND2X1 U239 ( .A(n189), .B(n226), .Y(n150) );
  INVX1 U240 ( .A(n160), .Y(n167) );
  NAND2X1 U241 ( .A(n188), .B(n227), .Y(n160) );
  NAND2X1 U242 ( .A(n225), .B(n228), .Y(N149) );
  INVX1 U243 ( .A(N158), .Y(n228) );
  NAND2X1 U244 ( .A(n222), .B(n229), .Y(N158) );
  NAND3X1 U245 ( .A(n222), .B(n230), .C(n186), .Y(N146) );
  NAND3X1 U246 ( .A(n231), .B(state[2]), .C(state[0]), .Y(n186) );
  INVX1 U247 ( .A(N147), .Y(n230) );
  NAND3X1 U248 ( .A(n187), .B(n144), .C(n232), .Y(N147) );
  INVX1 U249 ( .A(n171), .Y(n232) );
  NAND3X1 U250 ( .A(n178), .B(n191), .C(n225), .Y(n171) );
  NAND2X1 U251 ( .A(n188), .B(n233), .Y(n225) );
  INVX1 U252 ( .A(N157), .Y(n191) );
  NAND3X1 U253 ( .A(n207), .B(n229), .C(n224), .Y(N157) );
  NAND2X1 U254 ( .A(n226), .B(n231), .Y(n224) );
  INVX1 U255 ( .A(N159), .Y(n229) );
  NAND2X1 U256 ( .A(n221), .B(n223), .Y(N159) );
  NAND3X1 U257 ( .A(state[1]), .B(n227), .C(state[3]), .Y(n223) );
  NAND2X1 U258 ( .A(n231), .B(n233), .Y(n221) );
  NAND3X1 U259 ( .A(state[3]), .B(state[1]), .C(n226), .Y(n207) );
  NAND2X1 U260 ( .A(n226), .B(n188), .Y(n178) );
  NOR2X1 U261 ( .A(n234), .B(state[3]), .Y(n188) );
  NOR2X1 U262 ( .A(n235), .B(state[2]), .Y(n226) );
  NAND2X1 U263 ( .A(n231), .B(n227), .Y(n144) );
  AND2X1 U264 ( .A(state[3]), .B(n234), .Y(n231) );
  INVX1 U265 ( .A(state[1]), .Y(n234) );
  NAND2X1 U266 ( .A(n189), .B(n233), .Y(n187) );
  AND2X1 U267 ( .A(state[2]), .B(n235), .Y(n233) );
  INVX1 U268 ( .A(state[0]), .Y(n235) );
  NAND2X1 U269 ( .A(n189), .B(n227), .Y(n222) );
  NOR2X1 U270 ( .A(state[2]), .B(state[0]), .Y(n227) );
  NOR2X1 U271 ( .A(state[3]), .B(state[1]), .Y(n189) );
endmodule

