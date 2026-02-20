import { Body, Controller, Post } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { Public } from './public.decorator';

@ApiTags('인증')
@Controller('auth')
@Public()
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  @ApiOperation({ summary: '회원가입' })
  @ApiResponse({ status: 201, description: '가입 성공' })
  @ApiResponse({ status: 409, description: '이미 등록된 이메일' })
  async register(@Body() dto: RegisterDto) {
    return this.authService.register(dto.emailAddress, dto.password);
  }

  @Post('login')
  @ApiOperation({ summary: '로그인' })
  @ApiResponse({ status: 201, description: '로그인 성공' })
  @ApiResponse({ status: 401, description: '이메일 또는 비밀번호 불일치' })
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto.emailAddress, dto.password);
  }
}
