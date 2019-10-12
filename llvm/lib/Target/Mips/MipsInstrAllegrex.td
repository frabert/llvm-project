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

class VFR<bits<6> op, bits<3> sop, bits<2> sz, dag outs, dag ins, string asmstr,
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

multiclass VFR_I<bits<6> op, bits<3> sop, string name, list<dag> pattern>
{
  def _s : VFR<op, sop, 0, (outs VFPUS:$rd), (ins VFPUS:$rs, VFPUS:$rt),
               !strconcat(name, ".s $rd, $rs, $rt"), []>, ASE_ALLEGREX;
  def _p : VFR<op, sop, 1, (outs VFPUP:$rd), (ins VFPUP:$rs, VFPUP:$rt),
               !strconcat(name, ".p $rd, $rs, $rt"), []>, ASE_ALLEGREX;
  def _t : VFR<op, sop, 2, (outs VFPUT:$rd), (ins VFPUT:$rs, VFPUT:$rt),
               !strconcat(name, ".t $rd, $rs, $rt"), []>, ASE_ALLEGREX;
  def _q : VFR<op, sop, 3, (outs VFPUQ:$rd), (ins VFPUQ:$rs, VFPUQ:$rt),
               !strconcat(name, ".q $rd, $rs, $rt"), []>, ASE_ALLEGREX;
}

defm VADD : VFR_I<0b011000, 0b000, "vadd", []>;
defm VDIV : VFR_I<0b011000, 0b111, "vdiv", []>;

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

