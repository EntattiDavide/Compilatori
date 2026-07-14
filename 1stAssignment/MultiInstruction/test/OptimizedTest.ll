; ModuleID = 'Test.ll'
source_filename = "Test.ll"

define dso_local i32 @test(i32 noundef %0) {
  %2 = sub nsw i32 %0, 10
  %3 = mul nsw i32 %0, 2
  %4 = udiv i32 %3, 2
  %5 = udiv exact i32 %0, 2
  %6 = udiv i32 %0, 2
  %7 = mul i32 2, %6
  ret i32 %4
}
