define dso_local i32 @test(i32 noundef %0) #0 {
  %2 = mul nsw i32 %0, 4
  %3 = mul nsw i32 15, %0
  %4 = mul nsw i32 %0, 9

  %5 = udiv i32 %0, 8
  %6 = udiv i32 1, %0

  ret i32 %6
}