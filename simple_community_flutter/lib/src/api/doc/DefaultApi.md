# simple_community_api.api.DefaultApi

## Load the API package
```dart
import 'package:simple_community_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**appControllerHealth**](DefaultApi.md#appcontrollerhealth) | **GET** / | 헬스 체크
[**authControllerLogin**](DefaultApi.md#authcontrollerlogin) | **POST** /auth/login | 로그인
[**authControllerRegister**](DefaultApi.md#authcontrollerregister) | **POST** /auth/register | 회원가입
[**commentsControllerCreate**](DefaultApi.md#commentscontrollercreate) | **POST** /posts/{postId}/comments | 댓글 작성
[**commentsControllerFindAll**](DefaultApi.md#commentscontrollerfindall) | **GET** /posts/{postId}/comments | 댓글 목록 (페이지네이션)
[**commentsControllerRemove**](DefaultApi.md#commentscontrollerremove) | **DELETE** /posts/{postId}/comments/{id} | 댓글 삭제
[**postsControllerCreate**](DefaultApi.md#postscontrollercreate) | **POST** /posts | 게시글 작성
[**postsControllerFindAll**](DefaultApi.md#postscontrollerfindall) | **GET** /posts | 게시글 목록 (페이지네이션)
[**postsControllerFindOne**](DefaultApi.md#postscontrollerfindone) | **GET** /posts/{id} | 게시글 상세
[**postsControllerRemove**](DefaultApi.md#postscontrollerremove) | **DELETE** /posts/{id} | 게시글 삭제
[**postsControllerUpdate**](DefaultApi.md#postscontrollerupdate) | **PATCH** /posts/{id} | 게시글 수정


# **appControllerHealth**
> appControllerHealth()

헬스 체크

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();

try {
    api.appControllerHealth();
} on DioException catch (e) {
    print('Exception when calling DefaultApi->appControllerHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerLogin**
> authControllerLogin(loginDto)

로그인

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();
final LoginDto loginDto = ; // LoginDto | 

try {
    api.authControllerLogin(loginDto);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->authControllerLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginDto** | [**LoginDto**](LoginDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRegister**
> authControllerRegister(registerDto)

회원가입

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();
final RegisterDto registerDto = ; // RegisterDto | 

try {
    api.authControllerRegister(registerDto);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->authControllerRegister: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerDto** | [**RegisterDto**](RegisterDto.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsControllerCreate**
> commentsControllerCreate(postId, createCommentDto)

댓글 작성

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();
final num postId = 8.14; // num | 
final CreateCommentDto createCommentDto = ; // CreateCommentDto | 

try {
    api.commentsControllerCreate(postId, createCommentDto);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->commentsControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **postId** | **num**|  | 
 **createCommentDto** | [**CreateCommentDto**](CreateCommentDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsControllerFindAll**
> commentsControllerFindAll(postId, page, perPage)

댓글 목록 (페이지네이션)

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();
final num postId = 8.14; // num | 
final String page = page_example; // String | 
final String perPage = perPage_example; // String | 

try {
    api.commentsControllerFindAll(postId, page, perPage);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->commentsControllerFindAll: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **postId** | **num**|  | 
 **page** | **String**|  | 
 **perPage** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **commentsControllerRemove**
> commentsControllerRemove(postId, id)

댓글 삭제

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();
final num postId = 8.14; // num | 
final num id = 8.14; // num | 

try {
    api.commentsControllerRemove(postId, id);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->commentsControllerRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **postId** | **num**|  | 
 **id** | **num**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postsControllerCreate**
> postsControllerCreate(createPostDto)

게시글 작성

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();
final CreatePostDto createPostDto = ; // CreatePostDto | 

try {
    api.postsControllerCreate(createPostDto);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->postsControllerCreate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createPostDto** | [**CreatePostDto**](CreatePostDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postsControllerFindAll**
> postsControllerFindAll(page, perPage)

게시글 목록 (페이지네이션)

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();
final String page = page_example; // String | 
final String perPage = perPage_example; // String | 

try {
    api.postsControllerFindAll(page, perPage);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->postsControllerFindAll: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **String**|  | 
 **perPage** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postsControllerFindOne**
> postsControllerFindOne(id)

게시글 상세

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();
final num id = 8.14; // num | 

try {
    api.postsControllerFindOne(id);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->postsControllerFindOne: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **num**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postsControllerRemove**
> postsControllerRemove(id)

게시글 삭제

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();
final num id = 8.14; // num | 

try {
    api.postsControllerRemove(id);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->postsControllerRemove: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **num**|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postsControllerUpdate**
> postsControllerUpdate(id, updatePostDto)

게시글 수정

### Example
```dart
import 'package:simple_community_api/api.dart';

final api = SimpleCommunityApi().getDefaultApi();
final num id = 8.14; // num | 
final UpdatePostDto updatePostDto = ; // UpdatePostDto | 

try {
    api.postsControllerUpdate(id, updatePostDto);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->postsControllerUpdate: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **num**|  | 
 **updatePostDto** | [**UpdatePostDto**](UpdatePostDto.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

