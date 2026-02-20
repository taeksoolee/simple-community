//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:simple_community_api/src/date_serializer.dart';
import 'package:simple_community_api/src/model/date.dart';

import 'package:simple_community_api/src/model/create_comment_dto.dart';
import 'package:simple_community_api/src/model/create_post_dto.dart';
import 'package:simple_community_api/src/model/login_dto.dart';
import 'package:simple_community_api/src/model/register_dto.dart';
import 'package:simple_community_api/src/model/update_post_dto.dart';

part 'serializers.g.dart';

@SerializersFor([
  CreateCommentDto,
  CreatePostDto,
  LoginDto,
  RegisterDto,
  UpdatePostDto,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
