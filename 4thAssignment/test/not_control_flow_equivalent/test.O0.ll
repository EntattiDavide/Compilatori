; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local void @test_fusion(ptr noundef %0, ptr noundef %1, ptr noundef %2, ptr noundef %3, i32 noundef %4, i32 noundef %5) #0 {
  %7 = alloca ptr, align 8
  %8 = alloca ptr, align 8
  %9 = alloca ptr, align 8
  %10 = alloca ptr, align 8
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store ptr %0, ptr %7, align 8
  store ptr %1, ptr %8, align 8
  store ptr %2, ptr %9, align 8
  store ptr %3, ptr %10, align 8
  store i32 %4, ptr %11, align 4
  store i32 %5, ptr %12, align 4
  store i32 0, ptr %13, align 4
  br label %15

15:                                               ; preds = %25, %6
  %16 = load i32, ptr %13, align 4
  %17 = icmp slt i32 %16, 100
  br i1 %17, label %18, label %28

18:                                               ; preds = %15
  %19 = load i32, ptr %13, align 4
  %20 = mul nsw i32 %19, 2
  %21 = load ptr, ptr %7, align 8
  %22 = load i32, ptr %13, align 4
  %23 = sext i32 %22 to i64
  %24 = getelementptr inbounds i32, ptr %21, i64 %23
  store i32 %20, ptr %24, align 4
  br label %25

25:                                               ; preds = %18
  %26 = load i32, ptr %13, align 4
  %27 = add nsw i32 %26, 1
  store i32 %27, ptr %13, align 4
  br label %15, !llvm.loop !6

28:                                               ; preds = %15
  store i32 0, ptr %14, align 4
  br label %29

29:                                               ; preds = %43, %28
  %30 = load i32, ptr %14, align 4
  %31 = icmp slt i32 %30, 100
  br i1 %31, label %32, label %46

32:                                               ; preds = %29
  %33 = load ptr, ptr %7, align 8
  %34 = load i32, ptr %14, align 4
  %35 = sext i32 %34 to i64
  %36 = getelementptr inbounds i32, ptr %33, i64 %35
  %37 = load i32, ptr %36, align 4
  %38 = add nsw i32 %37, 1
  %39 = load ptr, ptr %8, align 8
  %40 = load i32, ptr %14, align 4
  %41 = sext i32 %40 to i64
  %42 = getelementptr inbounds i32, ptr %39, i64 %41
  store i32 %38, ptr %42, align 4
  br label %46

43:                                               ; No predecessors!
  %44 = load i32, ptr %14, align 4
  %45 = add nsw i32 %44, 1
  store i32 %45, ptr %14, align 4
  br label %29, !llvm.loop !8

46:                                               ; preds = %32, %29
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
