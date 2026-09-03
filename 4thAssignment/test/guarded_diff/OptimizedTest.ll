; ModuleID = '/mnt/c/Users/Power/Desktop/comp2/4thAssignment/test/guarded_diff/test.m2r.ll'
source_filename = "/mnt/c/Users/Power/Desktop/comp2/4thAssignment/test/guarded_diff/test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local void @test_fusion(ptr noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = icmp slt i32 0, %2
  br i1 %5, label %.lr.ph, label %13

.lr.ph:                                           ; preds = %4
  br label %6

6:                                                ; preds = %10, %.lr.ph
  %.012 = phi i32 [ 0, %.lr.ph ], [ %11, %10 ]
  %7 = mul nsw i32 %.012, 2
  %8 = sext i32 %.012 to i64
  %9 = getelementptr inbounds i32, ptr %0, i64 %8
  store i32 %7, ptr %9, align 4
  br label %10

10:                                               ; preds = %6
  %11 = add nsw i32 %.012, 1
  %12 = icmp slt i32 %11, %2
  br i1 %12, label %6, label %._crit_edge, !llvm.loop !6

._crit_edge:                                      ; preds = %10
  br label %13

13:                                               ; preds = %._crit_edge, %4
  %14 = icmp slt i32 0, %3
  br i1 %14, label %.lr.ph5, label %25

.lr.ph5:                                          ; preds = %13
  br label %15

15:                                               ; preds = %22, %.lr.ph5
  %.03 = phi i32 [ 0, %.lr.ph5 ], [ %23, %22 ]
  %16 = sext i32 %.03 to i64
  %17 = getelementptr inbounds i32, ptr %0, i64 %16
  %18 = load i32, ptr %17, align 4
  %19 = add nsw i32 %18, 1
  %20 = sext i32 %.03 to i64
  %21 = getelementptr inbounds i32, ptr %1, i64 %20
  store i32 %19, ptr %21, align 4
  br label %22

22:                                               ; preds = %15
  %23 = add nsw i32 %.03, 1
  %24 = icmp slt i32 %23, %3
  br i1 %24, label %15, label %._crit_edge6, !llvm.loop !8

._crit_edge6:                                     ; preds = %22
  br label %25

25:                                               ; preds = %._crit_edge6, %13
  ret void
}

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
