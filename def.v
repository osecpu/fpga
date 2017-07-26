`define STATE_FETCH0	4'd0
`define STATE_FETCH1	4'd1
`define STATE_EXEC		4'd3

`define BIT_CR_HLT		0

//
// OPs
//
`define OP_LBSET		8'h01
`define OP_LIMM16		8'h02

`define OP_OR			8'h10
`define OP_XOR			8'h11
`define OP_AND			8'h12

`define OP_ADD			8'h14
`define OP_SUB			8'h15

`define OP_SHL			8'h18
`define OP_SAR			8'h19

`define OP_CMPE			8'h20
`define OP_CMPNE		8'h21
`define OP_CMPL			8'h22
`define OP_CMPGE		8'h23
`define OP_CMPLE		8'h24
`define OP_CMPG			8'h25
`define OP_TSTZ			8'h26
`define OP_TSTNZ		8'h27

`define OP_LIMM32		8'hd0

`define OP_CP			8'hd2
`define OP_CPDR			8'hd3

`define OP_HLT			8'hF0

//
// Label Types
//
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

