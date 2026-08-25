// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'valued_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ValuedItem {

 String get nameVi; String get nameEn; String get category; String get condition; String get brandGuess; int get minVnd; int get maxVnd; double get confidence; String get reasoning;/// Từ khóa tìm kiếm do model gợi ý (ưu tiên dùng khi mở web).
 String get searchQuery;/// URL ảnh minh họa sản phẩm từ web.
 String get imageUrl;
/// Create a copy of ValuedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValuedItemCopyWith<ValuedItem> get copyWith => _$ValuedItemCopyWithImpl<ValuedItem>(this as ValuedItem, _$identity);

  /// Serializes this ValuedItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValuedItem&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.category, category) || other.category == category)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.brandGuess, brandGuess) || other.brandGuess == brandGuess)&&(identical(other.minVnd, minVnd) || other.minVnd == minVnd)&&(identical(other.maxVnd, maxVnd) || other.maxVnd == maxVnd)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nameVi,nameEn,category,condition,brandGuess,minVnd,maxVnd,confidence,reasoning,searchQuery,imageUrl);

@override
String toString() {
  return 'ValuedItem(nameVi: $nameVi, nameEn: $nameEn, category: $category, condition: $condition, brandGuess: $brandGuess, minVnd: $minVnd, maxVnd: $maxVnd, confidence: $confidence, reasoning: $reasoning, searchQuery: $searchQuery, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $ValuedItemCopyWith<$Res>  {
  factory $ValuedItemCopyWith(ValuedItem value, $Res Function(ValuedItem) _then) = _$ValuedItemCopyWithImpl;
@useResult
$Res call({
 String nameVi, String nameEn, String category, String condition, String brandGuess, int minVnd, int maxVnd, double confidence, String reasoning, String searchQuery, String imageUrl
});




}
/// @nodoc
class _$ValuedItemCopyWithImpl<$Res>
    implements $ValuedItemCopyWith<$Res> {
  _$ValuedItemCopyWithImpl(this._self, this._then);

  final ValuedItem _self;
  final $Res Function(ValuedItem) _then;

/// Create a copy of ValuedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nameVi = null,Object? nameEn = null,Object? category = null,Object? condition = null,Object? brandGuess = null,Object? minVnd = null,Object? maxVnd = null,Object? confidence = null,Object? reasoning = null,Object? searchQuery = null,Object? imageUrl = null,}) {
  return _then(ValuedItem(
nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,brandGuess: null == brandGuess ? _self.brandGuess : brandGuess // ignore: cast_nullable_to_non_nullable
as String,minVnd: null == minVnd ? _self.minVnd : minVnd // ignore: cast_nullable_to_non_nullable
as int,maxVnd: null == maxVnd ? _self.maxVnd : maxVnd // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,reasoning: null == reasoning ? _self.reasoning : reasoning // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ValuedItem].
extension ValuedItemPatterns on ValuedItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ValuedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ValuedItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ValuedItem value)  $default,){
final _that = this;
switch (_that) {
case _ValuedItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ValuedItem value)?  $default,){
final _that = this;
switch (_that) {
case _ValuedItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nameVi,  String nameEn,  String category,  String condition,  String brandGuess,  int minVnd,  int maxVnd,  double confidence,  String reasoning,  String searchQuery,  String imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ValuedItem() when $default != null:
return $default(_that.nameVi,_that.nameEn,_that.category,_that.condition,_that.brandGuess,_that.minVnd,_that.maxVnd,_that.confidence,_that.reasoning,_that.searchQuery,_that.imageUrl);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nameVi,  String nameEn,  String category,  String condition,  String brandGuess,  int minVnd,  int maxVnd,  double confidence,  String reasoning,  String searchQuery,  String imageUrl)  $default,) {final _that = this;
switch (_that) {
case _ValuedItem():
return $default(_that.nameVi,_that.nameEn,_that.category,_that.condition,_that.brandGuess,_that.minVnd,_that.maxVnd,_that.confidence,_that.reasoning,_that.searchQuery,_that.imageUrl);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nameVi,  String nameEn,  String category,  String condition,  String brandGuess,  int minVnd,  int maxVnd,  double confidence,  String reasoning,  String searchQuery,  String imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _ValuedItem() when $default != null:
return $default(_that.nameVi,_that.nameEn,_that.category,_that.condition,_that.brandGuess,_that.minVnd,_that.maxVnd,_that.confidence,_that.reasoning,_that.searchQuery,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ValuedItem extends ValuedItem {
  const _ValuedItem({required this.nameVi, this.nameEn = '', this.category = '', this.condition = '', this.brandGuess = '', required this.minVnd, required this.maxVnd, this.confidence = 0.5, this.reasoning = '', this.searchQuery = '', this.imageUrl = ''}): super._();
  factory _ValuedItem.fromJson(Map<String, dynamic> json) => _$ValuedItemFromJson(json);

@override final  String nameVi;
@override@JsonKey() final  String nameEn;
@override@JsonKey() final  String category;
@override@JsonKey() final  String condition;
@override@JsonKey() final  String brandGuess;
@override final  int minVnd;
@override final  int maxVnd;
@override@JsonKey() final  double confidence;
@override@JsonKey() final  String reasoning;
/// Từ khóa tìm kiếm do model gợi ý (ưu tiên dùng khi mở web).
@override@JsonKey() final  String searchQuery;
/// URL ảnh minh họa sản phẩm từ web.
@override@JsonKey() final  String imageUrl;

/// Create a copy of ValuedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ValuedItemCopyWith<_ValuedItem> get copyWith => __$ValuedItemCopyWithImpl<_ValuedItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ValuedItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ValuedItem&&(identical(other.nameVi, nameVi) || other.nameVi == nameVi)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.category, category) || other.category == category)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.brandGuess, brandGuess) || other.brandGuess == brandGuess)&&(identical(other.minVnd, minVnd) || other.minVnd == minVnd)&&(identical(other.maxVnd, maxVnd) || other.maxVnd == maxVnd)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.reasoning, reasoning) || other.reasoning == reasoning)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nameVi,nameEn,category,condition,brandGuess,minVnd,maxVnd,confidence,reasoning,searchQuery,imageUrl);

@override
String toString() {
  return 'ValuedItem(nameVi: $nameVi, nameEn: $nameEn, category: $category, condition: $condition, brandGuess: $brandGuess, minVnd: $minVnd, maxVnd: $maxVnd, confidence: $confidence, reasoning: $reasoning, searchQuery: $searchQuery, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$ValuedItemCopyWith<$Res> implements $ValuedItemCopyWith<$Res> {
  factory _$ValuedItemCopyWith(_ValuedItem value, $Res Function(_ValuedItem) _then) = __$ValuedItemCopyWithImpl;
@override @useResult
$Res call({
 String nameVi, String nameEn, String category, String condition, String brandGuess, int minVnd, int maxVnd, double confidence, String reasoning, String searchQuery, String imageUrl
});




}
/// @nodoc
class __$ValuedItemCopyWithImpl<$Res>
    implements _$ValuedItemCopyWith<$Res> {
  __$ValuedItemCopyWithImpl(this._self, this._then);

  final _ValuedItem _self;
  final $Res Function(_ValuedItem) _then;

/// Create a copy of ValuedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nameVi = null,Object? nameEn = null,Object? category = null,Object? condition = null,Object? brandGuess = null,Object? minVnd = null,Object? maxVnd = null,Object? confidence = null,Object? reasoning = null,Object? searchQuery = null,Object? imageUrl = null,}) {
  return _then(_ValuedItem(
nameVi: null == nameVi ? _self.nameVi : nameVi // ignore: cast_nullable_to_non_nullable
as String,nameEn: null == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as String,brandGuess: null == brandGuess ? _self.brandGuess : brandGuess // ignore: cast_nullable_to_non_nullable
as String,minVnd: null == minVnd ? _self.minVnd : minVnd // ignore: cast_nullable_to_non_nullable
as int,maxVnd: null == maxVnd ? _self.maxVnd : maxVnd // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,reasoning: null == reasoning ? _self.reasoning : reasoning // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ValuationResult {

 List<ValuedItem> get items; String get summary; String get marketNote;
/// Create a copy of ValuationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValuationResultCopyWith<ValuationResult> get copyWith => _$ValuationResultCopyWithImpl<ValuationResult>(this as ValuationResult, _$identity);

  /// Serializes this ValuationResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValuationResult&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.marketNote, marketNote) || other.marketNote == marketNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),summary,marketNote);

@override
String toString() {
  return 'ValuationResult(items: $items, summary: $summary, marketNote: $marketNote)';
}


}

/// @nodoc
abstract mixin class $ValuationResultCopyWith<$Res>  {
  factory $ValuationResultCopyWith(ValuationResult value, $Res Function(ValuationResult) _then) = _$ValuationResultCopyWithImpl;
@useResult
$Res call({
 List<ValuedItem> items, String summary, String marketNote
});




}
/// @nodoc
class _$ValuationResultCopyWithImpl<$Res>
    implements $ValuationResultCopyWith<$Res> {
  _$ValuationResultCopyWithImpl(this._self, this._then);

  final ValuationResult _self;
  final $Res Function(ValuationResult) _then;

/// Create a copy of ValuationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? summary = null,Object? marketNote = null,}) {
  return _then(ValuationResult(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ValuedItem>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,marketNote: null == marketNote ? _self.marketNote : marketNote // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ValuationResult].
extension ValuationResultPatterns on ValuationResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ValuationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ValuationResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ValuationResult value)  $default,){
final _that = this;
switch (_that) {
case _ValuationResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ValuationResult value)?  $default,){
final _that = this;
switch (_that) {
case _ValuationResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ValuedItem> items,  String summary,  String marketNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ValuationResult() when $default != null:
return $default(_that.items,_that.summary,_that.marketNote);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ValuedItem> items,  String summary,  String marketNote)  $default,) {final _that = this;
switch (_that) {
case _ValuationResult():
return $default(_that.items,_that.summary,_that.marketNote);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ValuedItem> items,  String summary,  String marketNote)?  $default,) {final _that = this;
switch (_that) {
case _ValuationResult() when $default != null:
return $default(_that.items,_that.summary,_that.marketNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ValuationResult extends ValuationResult {
  const _ValuationResult({required  List<ValuedItem> items, this.summary = '', this.marketNote = ''}): _items = items,super._();
  factory _ValuationResult.fromJson(Map<String, dynamic> json) => _$ValuationResultFromJson(json);

 final  List<ValuedItem> _items;
@override List<ValuedItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  String summary;
@override@JsonKey() final  String marketNote;

/// Create a copy of ValuationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ValuationResultCopyWith<_ValuationResult> get copyWith => __$ValuationResultCopyWithImpl<_ValuationResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ValuationResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ValuationResult&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.marketNote, marketNote) || other.marketNote == marketNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),summary,marketNote);

@override
String toString() {
  return 'ValuationResult(items: $items, summary: $summary, marketNote: $marketNote)';
}


}

/// @nodoc
abstract mixin class _$ValuationResultCopyWith<$Res> implements $ValuationResultCopyWith<$Res> {
  factory _$ValuationResultCopyWith(_ValuationResult value, $Res Function(_ValuationResult) _then) = __$ValuationResultCopyWithImpl;
@override @useResult
$Res call({
 List<ValuedItem> items, String summary, String marketNote
});




}
/// @nodoc
class __$ValuationResultCopyWithImpl<$Res>
    implements _$ValuationResultCopyWith<$Res> {
  __$ValuationResultCopyWithImpl(this._self, this._then);

  final _ValuationResult _self;
  final $Res Function(_ValuationResult) _then;

/// Create a copy of ValuationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? summary = null,Object? marketNote = null,}) {
  return _then(_ValuationResult(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ValuedItem>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,marketNote: null == marketNote ? _self.marketNote : marketNote // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ScanHistoryEntry {

 String get id; DateTime get createdAt; ValuationResult get result;
/// Create a copy of ScanHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanHistoryEntryCopyWith<ScanHistoryEntry> get copyWith => _$ScanHistoryEntryCopyWithImpl<ScanHistoryEntry>(this as ScanHistoryEntry, _$identity);

  /// Serializes this ScanHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,result);

@override
String toString() {
  return 'ScanHistoryEntry(id: $id, createdAt: $createdAt, result: $result)';
}


}

/// @nodoc
abstract mixin class $ScanHistoryEntryCopyWith<$Res>  {
  factory $ScanHistoryEntryCopyWith(ScanHistoryEntry value, $Res Function(ScanHistoryEntry) _then) = _$ScanHistoryEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, ValuationResult result
});


$ValuationResultCopyWith<$Res> get result;

}
/// @nodoc
class _$ScanHistoryEntryCopyWithImpl<$Res>
    implements $ScanHistoryEntryCopyWith<$Res> {
  _$ScanHistoryEntryCopyWithImpl(this._self, this._then);

  final ScanHistoryEntry _self;
  final $Res Function(ScanHistoryEntry) _then;

/// Create a copy of ScanHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? result = null,}) {
  return _then(ScanHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ValuationResult,
  ));
}
/// Create a copy of ScanHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ValuationResultCopyWith<$Res> get result {
  
  return $ValuationResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScanHistoryEntry].
extension ScanHistoryEntryPatterns on ScanHistoryEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanHistoryEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _ScanHistoryEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ScanHistoryEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  ValuationResult result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanHistoryEntry() when $default != null:
return $default(_that.id,_that.createdAt,_that.result);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  ValuationResult result)  $default,) {final _that = this;
switch (_that) {
case _ScanHistoryEntry():
return $default(_that.id,_that.createdAt,_that.result);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  ValuationResult result)?  $default,) {final _that = this;
switch (_that) {
case _ScanHistoryEntry() when $default != null:
return $default(_that.id,_that.createdAt,_that.result);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScanHistoryEntry implements ScanHistoryEntry {
  const _ScanHistoryEntry({required this.id, required this.createdAt, required this.result});
  factory _ScanHistoryEntry.fromJson(Map<String, dynamic> json) => _$ScanHistoryEntryFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  ValuationResult result;

/// Create a copy of ScanHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanHistoryEntryCopyWith<_ScanHistoryEntry> get copyWith => __$ScanHistoryEntryCopyWithImpl<_ScanHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,createdAt,result);

@override
String toString() {
  return 'ScanHistoryEntry(id: $id, createdAt: $createdAt, result: $result)';
}


}

/// @nodoc
abstract mixin class _$ScanHistoryEntryCopyWith<$Res> implements $ScanHistoryEntryCopyWith<$Res> {
  factory _$ScanHistoryEntryCopyWith(_ScanHistoryEntry value, $Res Function(_ScanHistoryEntry) _then) = __$ScanHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, ValuationResult result
});


@override $ValuationResultCopyWith<$Res> get result;

}
/// @nodoc
class __$ScanHistoryEntryCopyWithImpl<$Res>
    implements _$ScanHistoryEntryCopyWith<$Res> {
  __$ScanHistoryEntryCopyWithImpl(this._self, this._then);

  final _ScanHistoryEntry _self;
  final $Res Function(_ScanHistoryEntry) _then;

/// Create a copy of ScanHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? result = null,}) {
  return _then(_ScanHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ValuationResult,
  ));
}

/// Create a copy of ScanHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ValuationResultCopyWith<$Res> get result {
  
  return $ValuationResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
