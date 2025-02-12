part of 'coupon_cubit.dart';

abstract class CouponState extends Equatable {
   bool isFocused;

   CouponState({required this.isFocused});

  @override
  List<Object> get props => [isFocused];
}

class CouponInitial extends CouponState {
  CouponInitial() : super(isFocused: false);
}

class CouponLoading extends CouponState {
  CouponLoading()
      : super(isFocused: false);
}

class CouponApplied extends CouponState {
  final String couponCode;

  CouponApplied({required this.couponCode, required bool isFocused})
      : super(isFocused: isFocused);

  @override
  List<Object> get props => [couponCode, isFocused];
}

class CouponError extends CouponState {
  final String error;

  CouponError({required this.error, required bool isFocused})
      : super(isFocused: isFocused);

  @override
  List<Object> get props => [error, isFocused];
}

class CouponFocusState extends CouponState {
  CouponFocusState({required bool isFocused}) : super(isFocused: isFocused);
}
