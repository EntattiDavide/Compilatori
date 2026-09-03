; ModuleID = '/mnt/c/Users/Power/Desktop/comp2/4thAssignment/test/guarded_same/test.m2r.ll'
source_filename = "/mnt/c/Users/Power/Desktop/comp2/4thAssignment/test/guarded_same/test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local void @test_fusion(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = icmp slt i32 0, %2
  br i1 %4, label %.lr.ph, label %12

.lr.ph:                                           ; preds = %3
  br label %5

5:                                                ; preds = %9, %.lr.ph
  %.012 = phi i32 [ 0, %.lr.ph ], [ %10, %9 ]
  %6 = mul nsw i32 %.012, 2
  %7 = sext i32 %.012 to i64
  %8 = getelementptr inbounds i32, ptr %0, i64 %7
  store i32 %6, ptr %8, align 4
  br label %9

9:                                                ; preds = %5
  %10 = add nsw i32 %.012, 1
  %11 = icmp slt i32 %10, %2
  br i1 %11, label %5, label %._crit_edge, !llvm.loop !6

._crit_edge:                                      ; preds = %9
  br label %12

12:                                               ; preds = %._crit_edge, %3
  %13 = icmp slt i32 0, %2
  br i1 %13, label %.lr.ph5, label %24

.lr.ph5:                                          ; preds = %12
  br label %14

14:                                               ; preds = %21, %.lr.ph5
  %.03 = phi i32 [ 0, %.lr.ph5 ], [ %22, %21 ]
  %15 = sext i32 %.03 to i64
  %16 = getelementptr inbounds i32, ptr %0, i64 %15
  %17 = load i32, ptr %16, align 4
  %18 = add nsw i32 %17, 1
  %19 = sext i32 %.03 to i64
  %20 = getelementptr inbounds i32, ptr %1, i64 %19
  store i32 %18, ptr %20, align 4
  br label %21

21:                                               ; preds = %14
  %22 = add nsw i32 %.03, 1
  %23 = icmp slt i32 %22, %2
  br i1 %23, label %14, label %._crit_edge6, !llvm.loop !8

._crit_edge6:                                     ; preds = %21
  br label %24

24:                                               ; preds = %._crit_edge6, %12
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
