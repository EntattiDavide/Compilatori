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
  %15 = alloca i32, align 4
  store ptr %0, ptr %7, align 8
  store ptr %1, ptr %8, align 8
  store ptr %2, ptr %9, align 8
  store ptr %3, ptr %10, align 8
  store i32 %4, ptr %11, align 4
  store i32 %5, ptr %12, align 4
  store i32 0, ptr %13, align 4
  br label %16

16:                                               ; preds = %26, %6
  %17 = load i32, ptr %13, align 4
  %18 = icmp slt i32 %17, 100
  br i1 %18, label %19, label %29

19:                                               ; preds = %16
  %20 = load i32, ptr %13, align 4
  %21 = mul nsw i32 %20, 2
  %22 = load ptr, ptr %7, align 8
  %23 = load i32, ptr %13, align 4
  %24 = sext i32 %23 to i64
  %25 = getelementptr inbounds i32, ptr %22, i64 %24
  store i32 %21, ptr %25, align 4
  br label %26

26:                                               ; preds = %19
  %27 = load i32, ptr %13, align 4
  %28 = add nsw i32 %27, 1
  store i32 %28, ptr %13, align 4
  br label %16, !llvm.loop !6

29:                                               ; preds = %16
  store i32 0, ptr %14, align 4
  br label %30

30:                                               ; preds = %44, %29
  %31 = load i32, ptr %14, align 4
  %32 = icmp slt i32 %31, 100
  br i1 %32, label %33, label %47

33:                                               ; preds = %30
  %34 = load ptr, ptr %7, align 8
  %35 = load i32, ptr %14, align 4
  %36 = sext i32 %35 to i64
  %37 = getelementptr inbounds i32, ptr %34, i64 %36
  %38 = load i32, ptr %37, align 4
  %39 = add nsw i32 %38, 1
  %40 = load ptr, ptr %8, align 8
  %41 = load i32, ptr %14, align 4
  %42 = sext i32 %41 to i64
  %43 = getelementptr inbounds i32, ptr %40, i64 %42
  store i32 %39, ptr %43, align 4
  br label %44

44:                                               ; preds = %33
  %45 = load i32, ptr %14, align 4
  %46 = add nsw i32 %45, 1
  store i32 %46, ptr %14, align 4
  br label %30, !llvm.loop !8

47:                                               ; preds = %30
  store i32 0, ptr %15, align 4
  br label %48

48:                                               ; preds = %77, %47
  %49 = load i32, ptr %15, align 4
  %50 = icmp slt i32 %49, 100
  br i1 %50, label %51, label %80

51:                                               ; preds = %48
  %52 = load ptr, ptr %7, align 8
  %53 = load i32, ptr %15, align 4
  %54 = sext i32 %53 to i64
  %55 = getelementptr inbounds i32, ptr %52, i64 %54
  %56 = load i32, ptr %55, align 4
  %57 = add nsw i32 %56, 2
  %58 = load ptr, ptr %7, align 8
  %59 = load i32, ptr %15, align 4
  %60 = sext i32 %59 to i64
  %61 = getelementptr inbounds i32, ptr %58, i64 %60
  store i32 %57, ptr %61, align 4
  %62 = load ptr, ptr %8, align 8
  %63 = load i32, ptr %15, align 4
  %64 = sext i32 %63 to i64
  %65 = getelementptr inbounds i32, ptr %62, i64 %64
  %66 = load i32, ptr %65, align 4
  %67 = load ptr, ptr %7, align 8
  %68 = load i32, ptr %15, align 4
  %69 = sext i32 %68 to i64
  %70 = getelementptr inbounds i32, ptr %67, i64 %69
  %71 = load i32, ptr %70, align 4
  %72 = add nsw i32 %66, %71
  %73 = load ptr, ptr %9, align 8
  %74 = load i32, ptr %15, align 4
  %75 = sext i32 %74 to i64
  %76 = getelementptr inbounds i32, ptr %73, i64 %75
  store i32 %72, ptr %76, align 4
  br label %77

77:                                               ; preds = %51
  %78 = load i32, ptr %15, align 4
  %79 = add nsw i32 %78, 1
  store i32 %79, ptr %15, align 4
  br label %48, !llvm.loop !9

80:                                               ; preds = %48
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
!9 = distinct !{!9, !7}
