import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNotEmpty, IsOptional, IsInt, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class CreateCommentDto {
  @ApiProperty({ example: '댓글 내용', description: '댓글 본문' })
  @IsString()
  @IsNotEmpty({ message: '댓글 내용을 입력해주세요' })
  body: string;

  @ApiProperty({ example: 1, required: false, description: '대댓글인 경우 부모 댓글 ID' })
  @IsOptional()
  @IsInt()
  @Min(1)
  @Type(() => Number)
  parentId?: number;
}
