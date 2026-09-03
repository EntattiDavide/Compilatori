; ModuleID = 'test.m2r.ll'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local void @test_fusion(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3, i32 noundef %4, i32 noundef %5) #0 {
  br label %7

7:                                                ; preds = %34, %6
  %.02 = phi i32 [ 0, %6 ], [ %35, %34 ]
  %8 = icmp slt i32 %.02, 100
  br i1 %8, label %9, label %36

9:                                                ; preds = %7
  %10 = mul nsw i32 %.02, 2
  %11 = sext i32 %.02 to i64
  %12 = getelementptr inbounds i32, ptr %0, i64 %11
  store i32 %10, ptr %12, align 4
  %13 = sext i32 %.02 to i64
  %14 = getelementptr inbounds i32, ptr %0, i64 %13
  %15 = load i32, ptr %14, align 4
  %16 = add nsw i32 %15, 1
  %17 = sext i32 %.02 to i64
  %18 = getelementptr inbounds i32, ptr %1, i64 %17
  store i32 %16, ptr %18, align 4
  %19 = sext i32 %.02 to i64
  %20 = getelementptr inbounds i32, ptr %0, i64 %19
  %21 = load i32, ptr %20, align 4
  %22 = add nsw i32 %21, 2
  %23 = sext i32 %.02 to i64
  %24 = getelementptr inbounds i32, ptr %0, i64 %23
  store i32 %22, ptr %24, align 4
  %25 = sext i32 %.02 to i64
  %26 = getelementptr inbounds i32, ptr %1, i64 %25
  %27 = load i32, ptr %26, align 4
  %28 = sext i32 %.02 to i64
  %29 = getelementptr inbounds i32, ptr %0, i64 %28
  %30 = load i32, ptr %29, align 4
  %31 = add nsw i32 %27, %30
  %32 = sext i32 %.02 to i64
  %33 = getelementptr inbounds i32, ptr %2, i64 %32
  store i32 %31, ptr %33, align 4
  br label %34

34:                                               ; preds = %9
  %35 = add nsw i32 %.02, 1
  br label %7, !llvm.loop !6

36:                                               ; preds = %7
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
