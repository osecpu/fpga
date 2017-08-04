`define STATE_FETCH0	4'd0
`define STATE_FETCH1	4'd1
`define STATE_EXEC		4'd3

`define BIT_CR_HLT		0
`define BIT_CR_SKIP		1

//
// ALU OPs
//
`define ALU_OP_OR		4'h0
`define ALU_OP_XOR		4'h1
`define ALU_OP_AND		4'h2
`define ALU_OP_ADD		4'h4
`define ALU_OP_SUB		4'h5
//`define ALU_OP_MUL		4'h6
`define ALU_OP_SHL		4'h8
`define ALU_OP_SAR		4'h9
//`define ALU_OP_DIV		4'hA
//`define ALU_OP_MOD		4'hB

`define ALU_CC_E		4'h0
`define ALU_CC_NE		4'h1
`define ALU_CC_L		4'h2
`define ALU_CC_GE		4'h3
`define ALU_CC_LE		4'h4
`define ALU_CC_G		4'h5
`define ALU_CC_TSTZ		4'h6
`define ALU_CC_TSTNZ	4'h7

//
// OPs
//
`define OP_LBSET		8'h01
`define OP_LIMM16		8'h02
`define OP_PLIMM		8'h03
`define OP_CND			8'h04

`define OP_PADD			8'h0e
`define OP_PDIF			8'h0f

`define OP_OR			8'h10
`define OP_XOR			8'h11
`define OP_AND			8'h12

`define OP_ADD			8'h14
`define OP_SUB			8'h15

`define OP_SHL			8'h18
`define OP_SAR			8'h19

`define OP_PCP			8'h1e

`define OP_CMPE			8'h20
`define OP_CMPNE		8'h21
`define OP_CMPL			8'h22
`define OP_CMPGE		8'h23
`define OP_CMPLE		8'h24
`define OP_CMPG			8'h25
`define OP_TSTZ			8'h26
`define OP_TSTNZ		8'h27
//
`define OP_PCMPE		8'h28
`define OP_PCMPNE		8'h29
`define OP_PCMPL		8'h2a
`define OP_PCMPGE		8'h2b
`define OP_PCMPLE		8'h2c
`define OP_PCMPG		8'h2d

`define OP_LIMM32		8'hd0

`define OP_CP			8'hd2
`define OP_CPDR			8'hd3

`define OP_HLT			8'hF0

//
// Label Types
//
`define LBTYPE_UNDEFINED	6'h00
`define LBTYPE_VPTR			6'h01
`define LBTYPE_SINT8		6'h02
`define LBTYPE_UINT8		6'h03
`define LBTYPE_SINT16		6'h04
`define LBTYPE_UINT16		6'h05
`define LBTYPE_SINT32		6'h06
`define LBTYPE_UINT32		6'h07
`define LBTYPE_SINT4		6'h08
`define LBTYPE_UINT4		6'h09
`define LBTYPE_SINT2		6'h0A
`define LBTYPE_UINT2		6'h0B
`define LBTYPE_SINT1		6'h0C
`define LBTYPE_UINT1		6'h0D
`define LBTYPE_CODE			6'h3f

