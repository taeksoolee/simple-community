import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, MaxLength } from 'class-validator';

export class CreatePostDto {
  @ApiProperty({ example: '게시글 제목', description: '제목' })
  @IsString()
  @IsNotEmpty({ message: '제목을 입력해주세요' })
  @MaxLength(200, { message: '제목은 200자 이하여야 합니다' })
  title: string;

  @ApiProperty({ example: '본문 내용...', description: '본문' })
  @IsString()
  @IsNotEmpty({ message: '본문을 입력해주세요' })
  body: string;
}
