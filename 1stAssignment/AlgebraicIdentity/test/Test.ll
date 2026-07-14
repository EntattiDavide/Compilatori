define dso_local i32 @test(i32 noundef %0) #0 {
  %2 = sub nsw i32 0, %0
  %3 = sub nsw i32 %0, 0

  %4 = add nsw i32 %0, 0
  %5 = add nsw i32 0, %4
  %6 = add nsw i32 %5, 1 

  %7 = sdiv i32 %0, 1
  %8 = sdiv i32 %7, 4
  %9 = sdiv i32 1, %8

  %10 = mul nsw i32 %4, 1
  %11 = mul nsw i32 %10, %3

  ret i32 %6
}