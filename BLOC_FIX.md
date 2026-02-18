# BLoC Stream Error Fix

## Problem

The app was throwing this error:
```
DartError: Assertion failed: !_isCompleted
emit was called after an event handler completed normally.
This is usually due to an unawaited future in an event handler.
```

**Location**: `lib/presentation/bloc/slot/slot_bloc.dart:54`

## Root Cause

The `_onWatchSlots` method was using a manual `StreamSubscription` and calling `emit()` directly within the `listen()` callback:

```dart
// ❌ BAD - Causes the error
_slotsSubscription = _watchSlotsUseCase(event.parkingLotId).listen(
  (result) {
    result.fold(
      (failure) => add(SlotEvent as SlotEvent),
      (slots) {
        if (!isClosed) {
          emit(SlotLoaded(slots));  // ⚠️ emit after handler completes
        }
      },
    );
  },
);
```

**Why this fails:**
1. The `_onWatchSlots` event handler completes immediately after setting up the subscription
2. Firestore continues to send updates through the stream
3. When updates arrive, `emit()` is called after the handler has already completed
4. BLoC throws an assertion error because emit should only be called during the handler

## Solution

Use `emit.forEach()` which properly manages the stream lifecycle:

```dart
// ✅ GOOD - Proper stream handling
await emit.forEach<dynamic>(
  _watchSlotsUseCase(event.parkingLotId),
  onData: (result) {
    return result.fold(
      (failure) => SlotError(message: failure.message),
      (slots) => SlotLoaded(slots),
    );
  },
);
```

**Why this works:**
1. `emit.forEach()` keeps the event handler alive while the stream is active
2. The handler only completes when the stream completes or is cancelled
3. Each stream event properly triggers `onData` which returns a new state
4. BLoC manages the emit timing automatically

## Changes Made

### 1. Updated `_onWatchSlots` method
- Replaced manual `StreamSubscription` with `emit.forEach()`
- Removed `if (!isClosed)` check (no longer needed)
- Simplified error handling

### 2. Removed manual subscription management
- Removed `StreamSubscription? _slotsSubscription` field
- Removed subscription cancellation in close()
- Removed `dart:async` import

### 3. Result

**Before (48 lines of code with manual management):**
```dart
StreamSubscription? _slotsSubscription;

Future<void> _onWatchSlots(...) async {
  await _slotsSubscription?.cancel();
  emit(const SlotLoading());
  _slotsSubscription = _watchSlotsUseCase(...).listen(...);
}

@override
Future<void> close() {
  _slotsSubscription?.cancel();
  return super.close();
}
```

**After (cleaner, safer):**
```dart
Future<void> _onWatchSlots(...) async {
  emit(const SlotLoading());
  await emit.forEach<dynamic>(
    _watchSlotsUseCase(...),
    onData: (result) => result.fold(...),
  );
}
```

## Benefits

1. ✅ **No more assertion errors** - Proper stream lifecycle management
2. ✅ **Simpler code** - No manual subscription management
3. ✅ **Automatic cleanup** - BLoC handles cancellation when closed
4. ✅ **Type safe** - Proper error and success handling
5. ✅ **Real-time updates** - Firestore changes still update UI instantly

## Testing

After the fix:
- ✅ App starts without errors
- ✅ Parking lot list loads correctly
- ✅ Slot updates work in real-time
- ✅ No assertion errors in console
- ✅ State transitions work smoothly

## BLoC Best Practices

### For Streams in Event Handlers

**Use `emit.forEach()`:**
```dart
await emit.forEach<T>(
  stream,
  onData: (data) => YourState(data),
);
```

**Or use `emit.onEach()`:**
```dart
await emit.onEach<T>(
  stream,
  onData: (data) {
    emit(YourState(data));
  },
);
```

### For Regular Async Operations

**Always await:**
```dart
on<Event>((event, emit) async {
  final result = await someAsyncOperation();
  emit(NewState(result));
});
```

### Common Mistakes to Avoid

❌ **Don't** use manual subscriptions in event handlers
❌ **Don't** call emit after event handler completes
❌ **Don't** forget to await async operations
❌ **Don't** use `if (!isClosed)` checks (emit handles this)

✅ **Do** use `emit.forEach()` for streams
✅ **Do** use `async/await` for async operations
✅ **Do** let BLoC manage lifecycle automatically
✅ **Do** return states directly from `onData`

## References

- [BLoC Documentation - Stream Handling](https://bloclibrary.dev/#/coreconcepts?id=streams)
- [Flutter BLoC Package](https://pub.dev/packages/flutter_bloc)
- [emit.forEach() API](https://pub.dev/documentation/bloc/latest/bloc/Emitter/forEach.html)

---

**Status**: ✅ Fixed and tested
**Impact**: Critical bug fix for real-time updates
**Breaking Changes**: None
