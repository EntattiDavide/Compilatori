define dso_local i32 @test(i32 noundef %0) #0 {
  %2 = sub nsw i32 %0, 10
  %3 = add nsw i32 %2, 10

  %4 = mul nsw i32 %3, 2
  %5 = sdiv i32 %4, 2
  %6 = udiv i32 %4, 2

  %7 = udiv exact i32 %0, 2
  %8 = mul i32 2, %7

  %9 = udiv i32 %0, 2
  %10 = mul i32 2, %9

  ret i32 %6
}