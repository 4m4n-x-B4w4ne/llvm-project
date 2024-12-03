// RUN: %clang %s -serialize-diagnostics %s.diag || true
// RUN: clang-read-diagnostics %s.diag 2>&1 | FileCheck %s
// RUN: rm %s.diag

#include <stdio.h>

int forgot_return() {
  // CHECK: error_and_warning.c:9:1: non-void function does not return a value [category='Semantic Issue', flag=return-type]
}

int main() {
  // CHECK: error_and_warning.c:13:25: expected ';' after expression [category='Parse Issue']
  printf("Hello world!")
}
