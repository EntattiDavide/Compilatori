; ModuleID = 'test.m2r.ll'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local void @complex_licm_test(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, ptr noundef %5) #0 {
  %7 = add nsw i32 %0, %1
  %8 = mul nsw i32 %0, %1
  %9 = icmp sgt i32 %0, 0
  %10 = mul nsw i32 %1, %2
  %11 = add nsw i32 %0, %1
  %12 = add nsw i32 %11, %2
  %13 = add nsw i32 %1, %2
  %14 = add nsw i32 %8, %2
  br label %15

15:                                               ; preds = %49, %6
  %.02 = phi i32 [ 0, %6 ], [ %44, %49 ]
  %.01 = phi i32 [ 0, %6 ], [ %50, %49 ]
  %16 = icmp slt i32 %.01, %3
  br i1 %16, label %17, label %51

17:                                               ; preds = %15
  br label %18

18:                                               ; preds = %24, %17
  %.0 = phi i32 [ 0, %17 ], [ %25, %24 ]
  %19 = icmp slt i32 %.0, %4
  br i1 %19, label %20, label %26

20:                                               ; preds = %18
  %21 = add nsw i32 %14, %.0
  %22 = sext i32 %.0 to i64
  %23 = getelementptr inbounds i32, ptr %5, i64 %22
  store i32 %21, ptr %23, align 4
  br label %24

24:                                               ; preds = %20
  %25 = add nsw i32 %.0, 1
  br label %18, !llvm.loop !6

26:                                               ; preds = %18
  br i1 %9, label %27, label %30

27:                                               ; preds = %26
  %28 = sext i32 %.01 to i64
  %29 = getelementptr inbounds i32, ptr %5, i64 %28
  store i32 %13, ptr %29, align 4
  br label %33

30:                                               ; preds = %26
  %31 = sext i32 %.01 to i64
  %32 = getelementptr inbounds i32, ptr %5, i64 %31
  store i32 %10, ptr %32, align 4
  br label %33

33:                                               ; preds = %30, %27
  %34 = sext i32 %.01 to i64
  %35 = getelementptr inbounds i32, ptr %5, i64 %34
  %36 = load i32, ptr %35, align 4
  %37 = add nsw i32 %36, %12
  store i32 %37, ptr %35, align 4
  %38 = sext i32 %.01 to i64
  %39 = getelementptr inbounds i32, ptr %5, i64 %38
  %40 = load i32, ptr %39, align 4
  %41 = icmp sgt i32 %40, 100
  br i1 %41, label %42, label %43

42:                                               ; preds = %33
  br label %51

43:                                               ; preds = %33
  %44 = sub nsw i32 %0, %1
  %45 = sext i32 %.01 to i64
  %46 = getelementptr inbounds i32, ptr %5, i64 %45
  %47 = load i32, ptr %46, align 4
  %48 = sub nsw i32 %47, %44
  store i32 %48, ptr %46, align 4
  br label %49

49:                                               ; preds = %43
  %50 = add nsw i32 %.01, 1
  br label %15, !llvm.loop !8

51:                                               ; preds = %42, %15
  %52 = getelementptr inbounds i32, ptr %5, i64 0
  store i32 %.02, ptr %52, align 4
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
