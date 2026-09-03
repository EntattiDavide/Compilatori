; ModuleID = 'test.O0.ll'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local void @test_fusion(ptr noundef %0, ptr noundef %1, i32 noundef %2) #0 {
  %4 = icmp sgt i32 %2, 0
  br i1 %4, label %5, label %15

5:                                                ; preds = %3
  br label %6

6:                                                ; preds = %12, %5
  %.01 = phi i32 [ 0, %5 ], [ %13, %12 ]
  %7 = icmp slt i32 %.01, %2
  br i1 %7, label %8, label %14

8:                                                ; preds = %6
  %9 = mul nsw i32 %.01, 2
  %10 = sext i32 %.01 to i64
  %11 = getelementptr inbounds i32, ptr %0, i64 %10
  store i32 %9, ptr %11, align 4
  br label %12

12:                                               ; preds = %8
  %13 = add nsw i32 %.01, 1
  br label %6, !llvm.loop !6

14:                                               ; preds = %6
  br label %15

15:                                               ; preds = %14, %3
  %16 = icmp sgt i32 %2, 0
  br i1 %16, label %17, label %30

17:                                               ; preds = %15
  br label %18

18:                                               ; preds = %27, %17
  %.0 = phi i32 [ 0, %17 ], [ %28, %27 ]
  %19 = icmp slt i32 %.0, %2
  br i1 %19, label %20, label %29

20:                                               ; preds = %18
  %21 = sext i32 %.0 to i64
  %22 = getelementptr inbounds i32, ptr %0, i64 %21
  %23 = load i32, ptr %22, align 4
  %24 = add nsw i32 %23, 1
  %25 = sext i32 %.0 to i64
  %26 = getelementptr inbounds i32, ptr %1, i64 %25
  store i32 %24, ptr %26, align 4
  br label %27

27:                                               ; preds = %20
  %28 = add nsw i32 %.0, 1
  br label %18, !llvm.loop !8

29:                                               ; preds = %18
  br label %30

30:                                               ; preds = %29, %15
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
