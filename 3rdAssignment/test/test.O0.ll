; ModuleID = 'test.c'
source_filename = "test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: noinline nounwind uwtable
define dso_local void @complex_licm_test(i32 noundef %0, i32 noundef %1, i32 noundef %2, i32 noundef %3, i32 noundef %4, ptr noundef %5) #0 {
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca ptr, align 8
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  %20 = alloca i32, align 4
  %21 = alloca i32, align 4
  store i32 %0, ptr %7, align 4
  store i32 %1, ptr %8, align 4
  store i32 %2, ptr %9, align 4
  store i32 %3, ptr %10, align 4
  store i32 %4, ptr %11, align 4
  store ptr %5, ptr %12, align 8
  %22 = load i32, ptr %7, align 4
  %23 = load i32, ptr %8, align 4
  %24 = add nsw i32 %22, %23
  store i32 %24, ptr %13, align 4
  store i32 0, ptr %14, align 4
  store i32 0, ptr %15, align 4
  br label %25

25:                                               ; preds = %103, %6
  %26 = load i32, ptr %15, align 4
  %27 = load i32, ptr %10, align 4
  %28 = icmp slt i32 %26, %27
  br i1 %28, label %29, label %106

29:                                               ; preds = %25
  %30 = load i32, ptr %7, align 4
  %31 = load i32, ptr %8, align 4
  %32 = mul nsw i32 %30, %31
  store i32 %32, ptr %16, align 4
  store i32 0, ptr %17, align 4
  br label %33

33:                                               ; preds = %48, %29
  %34 = load i32, ptr %17, align 4
  %35 = load i32, ptr %11, align 4
  %36 = icmp slt i32 %34, %35
  br i1 %36, label %37, label %51

37:                                               ; preds = %33
  %38 = load i32, ptr %16, align 4
  %39 = load i32, ptr %9, align 4
  %40 = add nsw i32 %38, %39
  store i32 %40, ptr %18, align 4
  %41 = load i32, ptr %18, align 4
  %42 = load i32, ptr %17, align 4
  %43 = add nsw i32 %41, %42
  %44 = load ptr, ptr %12, align 8
  %45 = load i32, ptr %17, align 4
  %46 = sext i32 %45 to i64
  %47 = getelementptr inbounds i32, ptr %44, i64 %46
  store i32 %43, ptr %47, align 4
  br label %48

48:                                               ; preds = %37
  %49 = load i32, ptr %17, align 4
  %50 = add nsw i32 %49, 1
  store i32 %50, ptr %17, align 4
  br label %33, !llvm.loop !6

51:                                               ; preds = %33
  %52 = load i32, ptr %7, align 4
  %53 = icmp sgt i32 %52, 0
  br i1 %53, label %54, label %63

54:                                               ; preds = %51
  %55 = load i32, ptr %8, align 4
  %56 = load i32, ptr %9, align 4
  %57 = add nsw i32 %55, %56
  store i32 %57, ptr %19, align 4
  %58 = load i32, ptr %19, align 4
  %59 = load ptr, ptr %12, align 8
  %60 = load i32, ptr %15, align 4
  %61 = sext i32 %60 to i64
  %62 = getelementptr inbounds i32, ptr %59, i64 %61
  store i32 %58, ptr %62, align 4
  br label %72

63:                                               ; preds = %51
  %64 = load i32, ptr %8, align 4
  %65 = load i32, ptr %9, align 4
  %66 = mul nsw i32 %64, %65
  store i32 %66, ptr %20, align 4
  %67 = load i32, ptr %20, align 4
  %68 = load ptr, ptr %12, align 8
  %69 = load i32, ptr %15, align 4
  %70 = sext i32 %69 to i64
  %71 = getelementptr inbounds i32, ptr %68, i64 %70
  store i32 %67, ptr %71, align 4
  br label %72

72:                                               ; preds = %63, %54
  %73 = load i32, ptr %7, align 4
  %74 = load i32, ptr %8, align 4
  %75 = add nsw i32 %73, %74
  %76 = load i32, ptr %9, align 4
  %77 = add nsw i32 %75, %76
  store i32 %77, ptr %21, align 4
  %78 = load i32, ptr %21, align 4
  %79 = load ptr, ptr %12, align 8
  %80 = load i32, ptr %15, align 4
  %81 = sext i32 %80 to i64
  %82 = getelementptr inbounds i32, ptr %79, i64 %81
  %83 = load i32, ptr %82, align 4
  %84 = add nsw i32 %83, %78
  store i32 %84, ptr %82, align 4
  %85 = load ptr, ptr %12, align 8
  %86 = load i32, ptr %15, align 4
  %87 = sext i32 %86 to i64
  %88 = getelementptr inbounds i32, ptr %85, i64 %87
  %89 = load i32, ptr %88, align 4
  %90 = icmp sgt i32 %89, 100
  br i1 %90, label %91, label %92

91:                                               ; preds = %72
  br label %106

92:                                               ; preds = %72
  %93 = load i32, ptr %7, align 4
  %94 = load i32, ptr %8, align 4
  %95 = sub nsw i32 %93, %94
  store i32 %95, ptr %14, align 4
  %96 = load i32, ptr %14, align 4
  %97 = load ptr, ptr %12, align 8
  %98 = load i32, ptr %15, align 4
  %99 = sext i32 %98 to i64
  %100 = getelementptr inbounds i32, ptr %97, i64 %99
  %101 = load i32, ptr %100, align 4
  %102 = sub nsw i32 %101, %96
  store i32 %102, ptr %100, align 4
  br label %103

103:                                              ; preds = %92
  %104 = load i32, ptr %15, align 4
  %105 = add nsw i32 %104, 1
  store i32 %105, ptr %15, align 4
  br label %25, !llvm.loop !8

106:                                              ; preds = %91, %25
  %107 = load i32, ptr %14, align 4
  %108 = load ptr, ptr %12, align 8
  %109 = getelementptr inbounds i32, ptr %108, i64 0
  store i32 %107, ptr %109, align 4
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
