//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_post_dto.g.dart';

/// UpdatePostDto
///
/// Properties:
/// * [title] - 제목
/// * [body] - 본문
@BuiltValue()
abstract class UpdatePostDto implements Built<UpdatePostDto, UpdatePostDtoBuilder> {
  /// 제목
  @BuiltValueField(wireName: r'title')
  String? get title;

  /// 본문
  @BuiltValueField(wireName: r'body')
  String? get body;

  UpdatePostDto._();

  factory UpdatePostDto([void updates(UpdatePostDtoBuilder b)]) = _$UpdatePostDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdatePostDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdatePostDto> get serializer => _$UpdatePostDtoSerializer();
}

class _$UpdatePostDtoSerializer implements PrimitiveSerializer<UpdatePostDto> {
  @override
  final Iterable<Type> types = const [UpdatePostDto, _$UpdatePostDto];

  @override
  final String wireName = r'UpdatePostDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdatePostDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.body != null) {
      yield r'body';
      yield serializers.serialize(
        object.body,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdatePostDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UpdatePostDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UpdatePostDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdatePostDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

