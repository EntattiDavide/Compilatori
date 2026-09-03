; ModuleID = 'test.m2r.ll'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local void @test_fusion(ptr noundef %0, ptr noundef %1, i32 noundef %2, i32 noundef %3) #0 {
  %5 = icmp sgt i32 %2, 0
  br i1 %5, label %6, label %15

6:                                                ; preds = %4
  br label %7

7:                                                ; preds = %6, %11
  %.011 = phi i32 [ 0, %6 ], [ %12, %11 ]
  %8 = mul nsw i32 %.011, 2
  %9 = sext i32 %.011 to i64
  %10 = getelementptr inbounds i32, ptr %0, i64 %9
  store i32 %8, ptr %10, align 4
  br label %11

11:                                               ; preds = %7
  %12 = add nsw i32 %.011, 1
  %13 = icmp slt i32 %12, %2
  br i1 %13, label %7, label %14, !llvm.loop !6

14:                                               ; preds = %11
  br label %15

15:                                               ; preds = %14, %4
  %16 = icmp sgt i32 %3, 0
  br i1 %16, label %17, label %29

17:                                               ; preds = %15
  br label %18

18:                                               ; preds = %17, %25
  %.02 = phi i32 [ 0, %17 ], [ %26, %25 ]
  %19 = sext i32 %.02 to i64
  %20 = getelementptr inbounds i32, ptr %0, i64 %19
  %21 = load i32, ptr %20, align 4
  %22 = add nsw i32 %21, 1
  %23 = sext i32 %.02 to i64
  %24 = getelementptr inbounds i32, ptr %1, i64 %23
  store i32 %22, ptr %24, align 4
  br label %25

25:                                               ; preds = %18
  %26 = add nsw i32 %.02, 1
  %27 = icmp slt i32 %26, %3
  br i1 %27, label %18, label %28, !llvm.loop !8

28:                                               ; preds = %25
  br label %29

29:                                               ; preds = %28, %15
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
