; RUN: opt < %s -passes=lcssa,verify -S -o /dev/null

; This bugpoint reduced test case used to assert when removing unused PHI nodes.
; Just verify that we do not assert/crash.

define void @test(i1 %arg) {
entry:
  br label %gazank

gazank:
  %value = phi i16 [ 0, %entry ], [ undef, %gazonk ]
  br i1 %arg, label %gazink, label %qqq

gazink:
  br i1 %arg, label %gazonk, label %infinite.loop.pred

gazonk:
  br i1 %arg, label %exit1, label %gazank

qqq:
  br i1 %arg, label %www, label %exit2

www:
  br i1 %arg, label %qqq, label %foo.pred

foo.pred:
  br label %foo

foo:
  br i1 %arg, label %bar, label %exit1.pred

bar:
  br i1 %arg, label %foo, label %exit2.pred

unreachable1:
  br i1 %arg, label %foo, label %exit2.pred

exit1.pred:
  br label %exit1

exit1:
  ret void

exit2.pred:
  br label %exit2

exit2:
  ret void

infinite.loop.pred:
  br label %infinite.loop

infinite.loop:
  %dead = phi i16 [ %value, %infinite.loop.pred ], [ 0, %infinite.loop ]
  br label %infinite.loop
}
