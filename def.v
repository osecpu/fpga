`define STATE_FETCH0	4'd0
`define STATE_FETCH1	4'd1
`define STATE_EXEC		4'd3

`define BIT_CR_HLT		0

`define OP_LIMM16		8'h02
`define OP_HLT			8'hF0

`define LBTYPE_UNDEFINED	8'h00
`define LBTYPE_VPTR			8'h01
`define LBTYPE_SINT8		8'h02
`define LBTYPE_UINT8		8'h03
`define LBTYPE_SINT16		8'h04
`define LBTYPE_UINT16		8'h05
`define LBTYPE_SINT32		8'h06
`define LBTYPE_UINT32		8'h07
`define LBTYPE_SINT4		8'h08
`define LBTYPE_UINT4		8'h09
`define LBTYPE_SINT2		8'h0A
`define LBTYPE_UINT2		8'h0B
`define LBTYPE_SINT1		8'h0C
`define LBTYPE_UINT1		8'h0D
`define LBTYPE_CODE			8'h86

