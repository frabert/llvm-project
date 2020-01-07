//=- MipsInstrAllegrex.td - Allegrex Instruction Formats -*- tablegen -*- -===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes Allegrex instruction formats.
//
//===----------------------------------------------------------------------===//

def II_ALLEGREX : InstrItinClass;

class VFR_A<bits<6> op, bits<3> sop, bits<2> sz, dag outs, dag ins, string asmstr,
         list<dag> pattern>:
  InstSE<outs, ins, asmstr, pattern, II_ALLEGREX, FrmVFPU>
{
  bits<7> rd;
  bits<7> rs;
  bits<7> rt;
  bits<2> size = sz;
  bits<3> subopcode = sop;

  let Opcode      = op;

  let Inst{25-23} = subopcode;
  let Inst{22-16} = rt;
  let Inst{15}    = size{0};
  let Inst{14-8}  = rs;
  let Inst{7}     = size{1};
  let Inst{6-0}   = rd;
}

class VFR_B<bits<6> op, bits<3> sop, bits<2> sz, bits<7> rt, dag outs, dag ins, string asmstr,
         list<dag> pattern>:
  InstSE<outs, ins, asmstr, pattern, II_ALLEGREX, FrmVFPU>
{
  bits<7> rd;
  bits<7> rs;
  bits<2> size = sz;
  bits<3> subopcode = sop;

  let Opcode      = op;

  let Inst{25-23} = subopcode;
  let Inst{22-16} = rt;
  let Inst{15}    = size{0};
  let Inst{14-8}  = rs;
  let Inst{7}     = size{1};
  let Inst{6-0}   = rd;
}

class VFR_C<bits<6> op, bits<3> sop, bits<2> sz, bits<7> rs, bits<7> rt, dag outs, string asmstr,
         list<dag> pattern>:
  InstSE<outs, (ins), asmstr, pattern, II_ALLEGREX, FrmVFPU>
{
  bits<7> rd;
  bits<2> size = sz;
  bits<3> subopcode = sop;

  let Opcode      = op;

  let Inst{25-23} = subopcode;
  let Inst{22-16} = rt;
  let Inst{15}    = size{0};
  let Inst{14-8}  = rs;
  let Inst{7}     = size{1};
  let Inst{6-0}   = rd;
}

multiclass VFR_I_A<bits<6> op, bits<3> sop, string name, list<dag> pattern>
{
  def _S : VFR_A<op, sop, 0, (outs VFPUSOpnd:$rd), (ins VFPUSOpnd:$rs, VFPUSOpnd:$rt),
               !strconcat(name, ".s $rd, $rs, $rt"), []>, ASE_ALLEGREX;
  def _P : VFR_A<op, sop, 1, (outs VFPUPOpnd:$rd), (ins VFPUPOpnd:$rs, VFPUPOpnd:$rt),
               !strconcat(name, ".p $rd, $rs, $rt"), []>, ASE_ALLEGREX;
  def _T : VFR_A<op, sop, 2, (outs VFPUTOpnd:$rd), (ins VFPUTOpnd:$rs, VFPUTOpnd:$rt),
               !strconcat(name, ".t $rd, $rs, $rt"), []>, ASE_ALLEGREX;
  def _Q : VFR_A<op, sop, 3, (outs VFPUQOpnd:$rd), (ins VFPUQOpnd:$rs, VFPUQOpnd:$rt),
               !strconcat(name, ".q $rd, $rs, $rt"), []>, ASE_ALLEGREX;
}

multiclass VFR_I_B<bits<6> op, bits<3> sop, bits<7> rt, string name, list<dag> pattern>
{
  def _S : VFR_B<op, sop, 0, rt, (outs VFPUSOpnd:$rd), (ins VFPUSOpnd:$rs),
               !strconcat(name, ".s $rd, $rs"), []>, ASE_ALLEGREX;
  def _P : VFR_B<op, sop, 1, rt, (outs VFPUPOpnd:$rd), (ins VFPUPOpnd:$rs),
               !strconcat(name, ".p $rd, $rs"), []>, ASE_ALLEGREX;
  def _T : VFR_B<op, sop, 2, rt, (outs VFPUTOpnd:$rd), (ins VFPUTOpnd:$rs),
               !strconcat(name, ".t $rd, $rs"), []>, ASE_ALLEGREX;
  def _Q : VFR_B<op, sop, 3, rt, (outs VFPUQOpnd:$rd), (ins VFPUQOpnd:$rs),
               !strconcat(name, ".q $rd, $rs"), []>, ASE_ALLEGREX;
}

multiclass VFR_I_C<bits<6> op, bits<3> sop, bits<7> rs, bits<7> rt, string name, list<dag> pattern>
{
  def _P : VFR_C<op, sop, 1, rs, rt, (outs VFPUSOpnd:$rd),
               !strconcat(name, ".p $rd"), []>, ASE_ALLEGREX;
  def _T : VFR_C<op, sop, 2, rs, rt, (outs VFPUSOpnd:$rd),
               !strconcat(name, ".t $rd"), []>, ASE_ALLEGREX;
  def _Q : VFR_C<op, sop, 3, rs, rt, (outs VFPUSOpnd:$rd),
               !strconcat(name, ".q $rd"), []>, ASE_ALLEGREX;
}

defm VADD : VFR_I_A<0b011000, 0b000, "vadd", []>;
defm VSUB : VFR_I_A<0b011010, 0b000, "vsub", []>;
defm VDIV : VFR_I_A<0b011000, 0b111, "vdiv", []>;
defm VMUL : VFR_I_A<0b011001, 0b000, "vmul", []>;
defm VDOT : VFR_I_A<0b011001, 0b001, "vdot", []>;
defm VHDP : VFR_I_A<0b011001, 0b100, "vhdp", []>;
defm VMIN : VFR_I_A<0b011011, 0b010, "vmin", []>;
defm VMAX : VFR_I_A<0b011011, 0b011, "vmax", []>;

defm VABS : VFR_I_B<0b110100, 0b000, 0b0000001, "vabs", []>;
defm VNEG : VFR_I_B<0b110100, 0b000, 0b0000010, "vneg", []>;

defm VIDT  : VFR_I_C<0b110100, 0b000, 0b0000000, 0b0000011, "vidt", []>;
defm VZERO : VFR_I_C<0b110100, 0b000, 0b0000000, 0b0000110, "vzero", []>;
defm VONE  : VFR_I_C<0b110100, 0b000, 0b0000000, 0b0000111, "vone", []>;

defm VRCP   : VFR_I_B<0b110100, 0b000, 0b0010000, "vrcp", []>;
defm VRSQ   : VFR_I_B<0b110100, 0b000, 0b0010001, "vrsq", []>;
defm VSIN   : VFR_I_B<0b110100, 0b000, 0b0010010, "vsin", []>;
defm VCOS   : VFR_I_B<0b110100, 0b000, 0b0010011, "vcos", []>;
defm VEXP2  : VFR_I_B<0b110100, 0b000, 0b0010100, "vexp2", []>;
defm VLOG2  : VFR_I_B<0b110100, 0b000, 0b0010101, "vlog2", []>;
defm VSQRT  : VFR_I_B<0b110100, 0b000, 0b0010110, "vsqrt", []>;
defm VASIN  : VFR_I_B<0b110100, 0b000, 0b0010111, "vasin", []>;
defm VNRCP  : VFR_I_B<0b110100, 0b000, 0b0011000, "vnrcp", []>;
defm VNSIN  : VFR_I_B<0b110100, 0b000, 0b0011010, "vnsin", []>;
defm VREXP2 : VFR_I_B<0b110100, 0b000, 0b0011100, "vrexp2", []>;

/*
vi2uc.q rd,rs
vi2s.p rd,rs
vi2s.q rd,rs
*/

defm VSGN : VFR_I_B<0b110100, 0b000, 0b1001010, "vsgn", []>;

/*
vcst.s rd, a
vcst.p rd, a
vcst.t rd, a
vcst.q rd, a
*/

defm VF2IN : VFR_I_A<0b110100, 0b100, "vf2in", []>;
defm VI2F  : VFR_I_A<0b110100, 0b101, "vi2f", []>;

let rs = 0b00000, rt = 0b00000, rd = 0b00000, shamt = 0b00000 in {
  def HALT : FR<0b011100, 0b000000, (outs), (ins),
                "halt", [], II_ALLEGREX>, ASE_ALLEGREX;
}

let rs = 0b00000, shamt = 0b00000 in {
  def MFIC : FR<0b011100, 0b100100, (outs GPR32:$rd), (ins GPR32:$rt),
                "mfic $rt, $rd", [], II_ALLEGREX>, ASE_ALLEGREX;
                
  def MTIC : FR<0b011100, 0b100110, (outs GPR32:$rd), (ins GPR32:$rt),
                "mtic $rt, $rd", [], II_ALLEGREX>, ASE_ALLEGREX;
}

