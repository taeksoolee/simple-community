import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { Public } from './auth/public.decorator';

@ApiTags('헬스')
@Controller()
export class AppController {
  @Get()
  @Public()
  @ApiOperation({ summary: '헬스 체크' })
  health() {
    return { status: 'ok', message: 'Simple Community API' };
  }
}
