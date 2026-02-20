import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, MinLength } from 'class-validator';

export class RegisterDto {
  @ApiProperty({ example: 'user@example.com', description: '이메일 주소' })
  @IsEmail({}, { message: '올바른 이메일 형식이 아닙니다' })
  emailAddress: string;

  @ApiProperty({ example: 'password123', minLength: 6, description: '비밀번호 (6자 이상)' })
  @IsString()
  @MinLength(6, { message: '비밀번호는 6자 이상이어야 합니다' })
  password: string;
}
