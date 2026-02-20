import 'package:dio/dio.dart';

/// Dio/API 예외를 사용자 친화적 메시지로 변환
String parseApiError(dynamic e) {
  if (e is DioException) {
    return _parseDioException(e);
  }
  if (e is Exception) {
    final msg = e.toString();
    if (msg.startsWith('Exception: ')) {
      return msg.substring('Exception: '.length);
    }
    return msg;
  }
  return '오류가 발생했습니다';
}

String _parseDioException(DioException e) {
  // 서버 응답 본문에 message 필드가 있으면 사용 (NestJS 등)
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    final msg = data['message'];
    if (msg != null) {
      if (msg is String) return msg;
      if (msg is List && msg.isNotEmpty) return msg.first.toString();
      return msg.toString();
    }
    final errors = data['errors'] as List?;
    if (errors != null && errors.isNotEmpty) {
      return errors.first.toString();
    }
  }

  // HTTP 상태 코드별 기본 메시지
  final statusCode = e.response?.statusCode;
  if (statusCode != null) {
    switch (statusCode) {
      case 400:
        return '잘못된 요청입니다';
      case 401:
        return '로그인이 필요합니다';
      case 403:
        return '접근 권한이 없습니다';
      case 404:
        return '요청한 내용을 찾을 수 없습니다';
      case 409:
        return '이미 존재하는 항목입니다';
      case 422:
        return '입력값을 확인해주세요';
      case 500:
      case 502:
      case 503:
        return '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요';
    }
  }

  // DioException 타입별 메시지
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return '연결 시간이 초과되었습니다. 네트워크를 확인해주세요';
    case DioExceptionType.connectionError:
      return '서버에 연결할 수 없습니다. 네트워크를 확인해주세요';
    case DioExceptionType.badResponse:
      return '서버 응답 오류가 발생했습니다';
    case DioExceptionType.cancel:
      return '요청이 취소되었습니다';
    default:
      return '오류가 발생했습니다. 잠시 후 다시 시도해주세요';
  }
}
