; ModuleID = 'Test.ll'
source_filename = "Test.ll"

define dso_local i32 @test(i32 noundef %0) {
  %2 = sub nsw i32 0, %0
  %3 = add nsw i32 %0, 1
  %4 = sdiv i32 %0, 4
  %5 = sdiv i32 1, %4
  %6 = mul nsw i32 %0, %0
  ret i32 %3
}
