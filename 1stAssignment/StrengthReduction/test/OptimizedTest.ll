; ModuleID = 'Test.ll'
source_filename = "Test.ll"

define dso_local i32 @test(i32 noundef %0) {
  %2 = shl i32 %0, 2
  %3 = shl i32 %0, 4
  %4 = sub i32 %3, %0
  %5 = shl i32 %0, 3
  %6 = add i32 %5, %0
  %7 = lshr i32 %0, 3
  %8 = udiv i32 1, %0
  ret i32 %8
}
