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

let rs = 0b00000, rt = 0b00000, rd = 0b00000, shamt = 0b00000,
    DecoderMethod = "DecodeAllegrexHalt" in {
  def HALT : FR<0b011100, 0b000000, (outs), (ins),
                "halt", [], II_ALLEGREX>, ASE_ALLEGREX;
}

let rs = 0b00000, shamt = 0b00000 in {
  def MFIC : FR<0b011100, 0b100100, (outs GPR32:$rd), (ins GPR32:$rt),
                "mfic $rt, $rd", [], II_ALLEGREX>, ASE_ALLEGREX;
                
  def MTIC : FR<0b011100, 0b100110, (outs GPR32:$rd), (ins GPR32:$rt),
                "mtic $rt, $rd", [], II_ALLEGREX>, ASE_ALLEGREX;
}

