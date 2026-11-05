// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'period_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PeriodState {
  int get period => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PeriodStateCopyWith<PeriodState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeriodStateCopyWith<$Res> {
  factory $PeriodStateCopyWith(
          PeriodState value, $Res Function(PeriodState) then) =
      _$PeriodStateCopyWithImpl<$Res, PeriodState>;
  @useResult
  $Res call({int period});
}

/// @nodoc
class _$PeriodStateCopyWithImpl<$Res, $Val extends PeriodState>
    implements $PeriodStateCopyWith<$Res> {
  _$PeriodStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
  }) {
    return _then(_value.copyWith(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PeriodStateImplCopyWith<$Res>
    implements $PeriodStateCopyWith<$Res> {
  factory _$$PeriodStateImplCopyWith(
          _$PeriodStateImpl value, $Res Function(_$PeriodStateImpl) then) =
      __$$PeriodStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int period});
}

/// @nodoc
class __$$PeriodStateImplCopyWithImpl<$Res>
    extends _$PeriodStateCopyWithImpl<$Res, _$PeriodStateImpl>
    implements _$$PeriodStateImplCopyWith<$Res> {
  __$$PeriodStateImplCopyWithImpl(
      _$PeriodStateImpl _value, $Res Function(_$PeriodStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? period = null,
  }) {
    return _then(_$PeriodStateImpl(
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PeriodStateImpl implements _PeriodState {
  const _$PeriodStateImpl({required this.period});

  @override
  final int period;

  @override
  String toString() {
    return 'PeriodState(period: $period)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PeriodStateImpl &&
            (identical(other.period, period) || other.period == period));
  }

  @override
  int get hashCode => Object.hash(runtimeType, period);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PeriodStateImplCopyWith<_$PeriodStateImpl> get copyWith =>
      __$$PeriodStateImplCopyWithImpl<_$PeriodStateImpl>(this, _$identity);
}

abstract class _PeriodState implements PeriodState {
  const factory _PeriodState({required final int period}) = _$PeriodStateImpl;

  @override
  int get period;
  @override
  @JsonKey(ignore: true)
  _$$PeriodStateImplCopyWith<_$PeriodStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
