`timescale 1 ns/1 ns

module bmp2file_and_file2bmp;

integer fp_r, fp_w, step1;
reg [7:0] bmp_data[0:200000];
reg [31:0] timer;
reg clk;
reg [31:0] bmp_width,bmp_hight,data_start_index,bmp_size;
initial begin
timer = 32'd0;
clk = 1'b0;
forever #10 clk=~clk;
end
initial begin
fp_r = $fopen("lena256color24bit.bmp", "rb");
fp_w = $fopen("lena256color24bit_out.bmp", "wb");

step1 = $fread(bmp_data, fp_r);
bmp_width = {bmp_data[21],bmp_data[20],bmp_data[19],bmp_data[18]};
bmp_hight = {bmp_data[25],bmp_data[24],bmp_data[23],bmp_data[22]};
data_start_index = {bmp_data[13],bmp_data[12],bmp_data[11],bmp_data[10]};
bmp_size = {bmp_data[5],bmp_data[4],bmp_data[3],bmp_data[2]};
//run 4000000ns
#4000000
$fclose(fp_r);
/*
attention : must use fclose at the end of the programme,
else modelsim will be easily crashed and very slow beacause of no source file,
(i mean it's not wise to read reg when sorce file of reg is close).
it's horrible.
*/
$fclose(fp_w);
end

always@(posedge clk) begin
if (timer < (bmp_size+1)) begin
$fwrite(fp_w,"%c",bmp_data[timer]);
timer=timer+1'b1;
end
end

endmodule
