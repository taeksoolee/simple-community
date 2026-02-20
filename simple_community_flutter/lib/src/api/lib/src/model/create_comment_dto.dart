//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'create_comment_dto.g.dart';

/// CreateCommentDto
///
/// Properties:
/// * [body] - 댓글 본문
/// * [parentId] - 대댓글인 경우 부모 댓글 ID
@BuiltValue()
abstract class CreateCommentDto implements Built<CreateCommentDto, CreateCommentDtoBuilder> {
  /// 댓글 본문
  @BuiltValueField(wireName: r'body')
  String get body;

  /// 대댓글인 경우 부모 댓글 ID
  @BuiltValueField(wireName: r'parentId')
  num? get parentId;

  CreateCommentDto._();

  factory CreateCommentDto([void updates(CreateCommentDtoBuilder b)]) = _$CreateCommentDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CreateCommentDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CreateCommentDto> get serializer => _$CreateCommentDtoSerializer();
}

class _$CreateCommentDtoSerializer implements PrimitiveSerializer<CreateCommentDto> {
  @override
  final Iterable<Type> types = const [CreateCommentDto, _$CreateCommentDto];

  @override
  final String wireName = r'CreateCommentDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CreateCommentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'body';
    yield serializers.serialize(
      object.body,
      specifiedType: const FullType(String),
    );
    if (object.parentId != null) {
      yield r'parentId';
      yield serializers.serialize(
        object.parentId,
        specifiedType: const FullType(num),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CreateCommentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CreateCommentDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'body':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.body = valueDes;
          break;
        case r'parentId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.parentId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CreateCommentDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CreateCommentDtoBuilder();
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

