; ModuleID = 'test.O0.ll'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [26 x i8] c"Interruzione tra i cicli\0A\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local void @test_fusion(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3, i32 noundef %4, i32 noundef %5) #0 {
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
  %16 = call i32 (ptr, ...) @printf(ptr noundef @.str)
  br label %17

17:                                               ; preds = %23, %15
  %.0 = phi i32 [ 0, %15 ], [ %24, %23 ]
  %18 = icmp slt i32 %.0, 100
  br i1 %18, label %19, label %25

19:                                               ; preds = %17
  %20 = mul nsw i32 %.0, 3
  %21 = sext i32 %.0 to i64
  %22 = getelementptr inbounds i32, ptr %2, i64 %21
  store i32 %20, ptr %22, align 4
  br label %23

23:                                               ; preds = %19
  %24 = add nsw i32 %.0, 1
  br label %17, !llvm.loop !8

25:                                               ; preds = %17
  ret void
}

declare i32 @printf(ptr noundef, ...) #1

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

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
