$date
   Sat May 16 19:24:52 2026
$end

$version
  2025.2
  $dumpfile ("wave.fst") 
$end

$timescale
  1ps
$end

$scope module tb_rw_sync_fsm $end
$var reg 1 ! clk $end
$var reg 1 " rst $end
$var reg 1 # do_write $end
$var reg 1 $ exec $end
$var reg 1 % rd_wr $end
$var reg 32 & err_cnt [31:0] $end
$var reg 32 ' done_cnt [31:0] $end
$scope module dut $end
$var wire 1 ( clk $end
$var wire 1 ) rst $end
$var wire 1 * do_write $end
$var reg 1 $ exec $end
$var reg 1 % rd_wr $end
$var reg 2 + cstate $end
$var reg 2 , nstate $end
$upscope $end
$scope task reset_phase $end
$upscope $end
$scope task run_phase $end
$upscope $end
$scope task report_phase $end
$upscope $end
$upscope $end
$enddefinitions $end

#0
$dumpvars
0!
1"
0#
0$
1%
b0 &
b0 '
0(
1)
0*
b0 +
b1 ,
$end

#5000
1!
1(

#10000
0!
0(

#15000
1!
0"
1(
0)

#20000
0!
0(

#25000
1!
0%
1(
b1 +
b11 ,

#30000
0!
0(

#35000
1!
1$
1%
1(
b11 +
b0 ,

#40000
0!
0(

#45000
1!
1#
0$
b1 '
1(
1*
b0 +
b10 ,

#50000
0!
0(

#55000
1!
1(
b10 +
b11 ,

#60000
0!
0(

#65000
1!
1$
1(
b11 +
b0 ,

#70000
0!
0(

#75000
1!
0#
0$
b10 '
1(
0*
b0 +
b1 ,

#80000
0!
0(

#85000
1!
1#
0%
1(
1*
b1 +

#90000
0!
0(

#95000
1!
1(

#100000
0!
0(

#105000
1!
1(

#110000
0!
0(

#115000
1!
1(

#120000
0!
0(

#125000
1!
0#
1(
0*
b11 ,

#130000
0!
0(

#135000
1!
1$
1%
1(
b11 +
b0 ,

#140000
0!
0(

#145000
1!
1#
0$
b11 '
1(
1*
b0 +
b10 ,

#150000
0!
0(

#155000
1!
0#
1(
0*
b10 +

#160000
0!
0(

#165000
1!
1(

#170000
0!
0(

#175000
1!
1(

#180000
0!
0(

#185000
1!
1(

#190000
0!
0(

#195000
1!
1#
1(
1*
b11 ,

#200000
0!
0(

#205000
1!
1$
1(
b11 +
b0 ,

#210000
0!
0(

#215000
1!
0$
b100 '
1(
b0 +
b10 ,

#220000
0!
0(

#225000
1!
1(
