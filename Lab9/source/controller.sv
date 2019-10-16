module controller(
		input wire clk,
		input wire n_rst,
		input wire dr,
		input wire lc,
		input wire overflow,
		output reg cnt_up,
		output reg clear,
		output wire modwait,
		output reg [2:0] op,
		output reg [3:0] src1,
		output reg [3:0] src2,
		output reg [3:0] dest,
		output reg err
		);

typedef enum bit [4:0] {Idle, Load1, Wait1, Load2, Wait2, Load3, Wait3, Load4, Store1, Zero1, Sort1, Sort2, Sort3, Sort4, Mul1, Sub1, Mul2, Add1, Mul3, Sub2, Mul4, Add2, Cntup, Eidle} states;
reg next_hold;
reg current_hold;
states current;
states next;
always_ff @ (posedge clk, negedge n_rst)
	begin
	if(!n_rst)
		begin
		current <= Idle;
		current_hold <= 0;
		end
	else
		begin
		current <= next;
		current_hold <= next_hold;
		end
	end
	assign modwait=current_hold;
always_comb
	begin
	cnt_up=0;
	err=0;
	next=current;
	next_hold=current_hold;
	clear=0;
	op=0;
	src1=0;
	src2=0;
	dest=0;
	case (current)
		Idle:
		begin
		if (lc)
			begin
			next=Load1;
			next_hold=1;
		end
		else if (dr)
			begin
			next=Store1;
			next_hold=1;
			end
		else
			begin
			next=Idle;
			next_hold=0;
			end
		err=0;
		cnt_up =0;
		op=3'b000;
		clear=0;
		end

		Load1:
		begin
		next=Wait1;
		next_hold=0;
		err=0;
		op=3'b011;
		cnt_up=0;
		clear=1;
		dest=1;
		end

		Wait1:
		begin
		if (lc)
			begin
			next=Load2;
			next_hold=1;
			end
		else
			begin
			next=Wait1;
			next_hold=0;
			end
		err=0;
		cnt_up=3'b000;
		clear=0;
		op=0;
		end

		Load2:
		begin
		next=Wait2;
		next_hold=0;
		clear=0;
		cnt_up =0;
		op=3'b011;
		err=0;
		dest=2;
		end

		Wait2:
		begin
		if (lc)
			begin
			next=Load3;
			next_hold=1;
			end
		else
			begin
			next=Wait2;
			next_hold=0;
			end
		err=0;
		clear=0;
		op=3'b000;
		cnt_up=0;
		end

		Load3:
		begin
		next=Wait3;
		next_hold=0;
		clear=0;
		cnt_up=0;
		err=0;
		op=3'b011;
		dest=3;
		end

		Wait3:
		begin
		if (lc)
			begin
			next=Load4;
			next_hold=1;
			end
		else
			begin
			next=Wait3;
			next_hold=0;
			end
		err=0;
		clear=0;
		op=3'b000;
		cnt_up=0;
		end

		Load4:
		begin
		next=Idle;
		op=3'b011;
		next_hold=0;
		clear=0;
		cnt_up=0;
		err=0;
		dest=4;
		end

		Store1:
		begin
		if (dr)
			begin
			next=Zero1;
			next_hold=1;
			end
		else
			begin
			next=Eidle;
			next_hold=0;
			end
		err=0;
		clear=0;
		op=3'b010;
		dest=5;
		cnt_up=0;
		end

		Zero1:
		begin
		next=Sort1;
		next_hold=1;
		op=3'b101;
		err  =0;
		src1=0;
		src2=0;
		dest=0;
		clear=0;
		cnt_up=0;
		end

		Sort1:
		begin
		next=Sort2;
		next_hold=1;
		op =3'b001;
		err=0;
		clear=0;
		cnt_up=0;
		dest=9;
		src1=8;
		end

		Sort2:
		begin
		next=Sort3;
		next_hold=1;
		err=0;
		clear=0;
		cnt_up=0;
		op =3'b001;
		dest=8;
		src1= 7;
		end

		Sort3:
		begin
		next=Sort4;
		next_hold=1;
		err=0;
		clear=0;
		cnt_up=0;
		op =3'b001;
		dest=7;
		src1= 6;
		end

		Sort4:
		begin
		next=Mul1;
		next_hold=1;
		err=0;
		clear=0;
		cnt_up=0;
		op =3'b001;
		dest=6;
		src1= 5;
		end

		Mul1:
		begin
		next=Sub1;
		next_hold=1;
		cnt_up=0;
		clear=0;
		err=0;
		op=3'b110;
		dest=10;
		src1=1;
		src2=6;
		end

		Sub1:
		begin
		if (overflow == 1)
			begin
			next_hold=0;
			next=Eidle;
			end
		else
			begin
			next=Mul2;
			next_hold=1;
			end
		cnt_up=0;
		clear=0;
		err=0;
		op=3'b101;
		dest=0;
		src1=0;
		src2=10;
		end

		Mul2:
		begin
		next=Add1;
		next_hold=1 ;
		op=3'b110;
		cnt_up=0;
		clear=0;
		dest=11;
		src1=2;
		src2=7;
		err=0;
		end

		Add1:
		begin
		if (overflow)
			begin
			next=Eidle;
			next_hold=0;
			end
		else
			begin
			next=Mul3;
			next_hold=1;
			end
		cnt_up=0;
		clear=0;
		op=3'b100;
		src1=0;
		src2=11;
		dest=0;
		err=0;
		end

		Mul3:
		begin
		next=Sub2;
		next_hold= 1;
		cnt_up=0;
		clear=0;
		err=0;
		op=3'b110;
		dest=12;
		src1=3;
		src2=8;
		end

		Sub2:
		begin
		if (overflow)
			begin
			next_hold=0;
			next=Eidle;
			end
		else
			begin
			next=Mul4 ;
			next_hold=1;
			end
		cnt_up=0;
		clear=0;
		err=0;
		op=3'b101;
		dest=0;
		src1=0;
		src2=12;
		end

		Mul4:
		begin
		next=Add2;
		next_hold=1;
		cnt_up=0;
		clear=0;
		err=0;
		op=3'b110;
		dest=13;
		src1=4;
		src2=9;
		end

		Add2:
		begin
		if (overflow)
			begin
			next=Eidle;
			next_hold=0;
			end
		else
			begin
			next=Cntup;
			next_hold=1;
			end
		cnt_up=0;
		clear=0;
		err=0;
		op=3'b100;
		dest=0;
		src1=0;
		src2=13;
		end

		Cntup:
		begin
		cnt_up= 1;
		next=Idle;
		next_hold=0;
		err=0;
		clear=0;
		op=3'b000;
		src1=0;
		src2=0;
		dest=0;
		end

		Eidle:
		begin
		if (dr)
			begin
			next=Store1;
			next_hold=1;
			end
		else
			begin
			next=Eidle;
			next_hold=0;
			end
		err=1;
		clear=0;
		op=3'b000;
		cnt_up=0;
		end
	endcase
	end

endmodule
