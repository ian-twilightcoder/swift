// REQUIRES: swift_swift_parser

// RUN: %target-swift-frontend %s -swift-version 5 -module-name main -disable-availability-checking -typecheck -plugin-path %swift-plugin-dir -strict-memory-safety -warnings-as-errors -dump-macro-expansions 2>&1 | %FileCheck --match-full-lines %s

@_SwiftifyImport(.sizedBy(pointer: .param(1), size: "size * count"))
func myFunc(_ ptr: UnsafeRawPointer, _ size: CInt, _ count: CInt) {
}

// CHECK:      @_alwaysEmitIntoClient @_disfavoredOverload
// CHECK-NEXT: func myFunc(_ ptr: UnsafeRawBufferPointer, _ size: CInt, _ count: CInt) {
// CHECK-NEXT:     let _ptrCount: some BinaryInteger = size * count
// CHECK-NEXT:     if ptr.count < _ptrCount || _ptrCount < 0 {
// CHECK-NEXT:         fatalError("bounds check failure when calling unsafe function")
// CHECK-NEXT:     }
// CHECK-NEXT:     return unsafe myFunc(ptr.baseAddress!, size, count)
// CHECK-NEXT: }
