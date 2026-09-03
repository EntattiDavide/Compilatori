; ModuleID = 'test.m2r.ll'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local void @test_fusion(ptr noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = icmp sgt i32 %2, 0
  br i1 %5, label %6, label %16

6:                                                ; preds = %4
  br label %7

7:                                                ; preds = %13, %6
  %.01 = phi i32 [ 0, %6 ], [ %14, %13 ]
  %8 = icmp slt i32 %.01, 100
  br i1 %8, label %9, label %15

9:                                                ; preds = %7
  %10 = mul nsw i32 %.01, 2
  %11 = sext i32 %.01 to i64
  %12 = getelementptr inbounds i32, ptr %0, i64 %11
  store i32 %10, ptr %12, align 4
  br label %13

13:                                               ; preds = %9
  %14 = add nsw i32 %.01, 1
  br label %7, !llvm.loop !6

15:                                               ; preds = %7
  br label %16

16:                                               ; preds = %15, %4
  %17 = icmp sgt i32 %3, 0
  br i1 %17, label %18, label %31

18:                                               ; preds = %16
  br label %19

19:                                               ; preds = %28, %18
  %.0 = phi i32 [ 0, %18 ], [ %29, %28 ]
  %20 = icmp slt i32 %.0, 100
  br i1 %20, label %21, label %30

21:                                               ; preds = %19
  %22 = sext i32 %.0 to i64
  %23 = getelementptr inbounds i32, ptr %0, i64 %22
  %24 = load i32, ptr %23, align 4
  %25 = add nsw i32 %24, 1
  %26 = sext i32 %.0 to i64
  %27 = getelementptr inbounds i32, ptr %1, i64 %26
  store i32 %25, ptr %27, align 4
  br label %28

28:                                               ; preds = %21
  %29 = add nsw i32 %.0, 1
  br label %19, !llvm.loop !8

30:                                               ; preds = %19
  br label %31

31:                                               ; preds = %30, %16
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
!5 = !{!"Ubuntu clang version 19.1.7 (20ubuntu4)"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
