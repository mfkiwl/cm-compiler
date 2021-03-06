; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mattr=+avx < %s | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-scei-ps4"

@G1 = common global <2 x float> zeroinitializer, align 8
@G2 = common global <8 x float> zeroinitializer, align 32

define <4 x float> @foo() {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    vblendpd {{.*#+}} ymm0 = ymm0[0],mem[1,2,3]
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm1
; CHECK-NEXT:    vshufps {{.*#+}} xmm0 = xmm1[0,2],xmm0[2,0]
; CHECK-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,1,3]
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %V = load <2 x float>, <2 x float>* @G1, align 8
  %shuffle = shufflevector <2 x float> %V, <2 x float> undef, <8 x i32> <i32 undef, i32 undef, i32 undef, i32 undef, i32 0, i32 undef, i32 undef, i32 undef>
  %L = load <8 x float>, <8 x float>* @G2, align 32
  %shuffle1 = shufflevector <8 x float> %shuffle, <8 x float> %L, <4 x i32> <i32 12, i32 10, i32 14, i32 4>
  ret <4 x float> %shuffle1
}
