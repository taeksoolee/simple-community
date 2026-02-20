//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_post_dto.g.dart';

/// CreatePostDto
///
/// Properties:
/// * [title] - 제목
/// * [body] - 본문
@BuiltValue()
abstract class CreatePostDto implements Built<CreatePostDto, CreatePostDtoBuilder> {
  /// 제목
  @BuiltValueField(wireName: r'title')
  String get title;

  /// 본문
  @BuiltValueField(wireName: r'body')
  String get body;

  CreatePostDto._();

  factory CreatePostDto([void updates(CreatePostDtoBuilder b)]) = _$CreatePostDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreatePostDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreatePostDto> get serializer => _$CreatePostDtoSerializer();
}

class _$CreatePostDtoSerializer implements PrimitiveSerializer<CreatePostDto> {
  @override
  final Iterable<Type> types = const [CreatePostDto, _$CreatePostDto];

  @override
  final String wireName = r'CreatePostDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreatePostDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CreatePostDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreatePostDtoBuilder result,
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
  CreatePostDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreatePostDtoBuilder();
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

