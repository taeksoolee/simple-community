import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  ParseIntPipe,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { PostsService } from './posts.service';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { Public } from '../auth/public.decorator';

@ApiTags('게시글')
@Controller('posts')
export class PostsController {
  constructor(private postsService: PostsService) {}

  @Get()
  @Public()
  @ApiOperation({ summary: '게시글 목록 (페이지네이션)' })
  @ApiResponse({ status: 200, description: '성공' })
  async findAll(
    @Query('page') page?: string,
    @Query('perPage') perPage?: string,
  ) {
    const pageNum = page ? parseInt(page, 10) : 1;
    const perPageNum = perPage ? parseInt(perPage, 10) : 10;
    return this.postsService.findAll(pageNum, perPageNum);
  }

  @Get(':id')
  @Public()
  @ApiOperation({ summary: '게시글 상세' })
  @ApiResponse({ status: 200, description: '성공' })
  @ApiResponse({ status: 404, description: '없음' })
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return this.postsService.findOne(id);
  }

  @Post()
  @ApiBearerAuth()
  @ApiOperation({ summary: '게시글 작성' })
  @ApiResponse({ status: 201, description: '작성됨' })
  async create(
    @CurrentUser() user: import('../auth/current-user.decorator').CurrentUserPayload,
    @Body() dto: CreatePostDto,
  ) {
    return this.postsService.create(user.id, dto);
  }

  @Patch(':id')
  @ApiBearerAuth()
  @ApiOperation({ summary: '게시글 수정' })
  @ApiResponse({ status: 200, description: '수정됨' })
  @ApiResponse({ status: 403, description: '권한 없음' })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: import('../auth/current-user.decorator').CurrentUserPayload,
    @Body() dto: UpdatePostDto,
  ) {
    return this.postsService.update(id, user.id, dto);
  }

  @Delete(':id')
  @ApiBearerAuth()
  @ApiOperation({ summary: '게시글 삭제' })
  @ApiResponse({ status: 200, description: '삭제됨' })
  @ApiResponse({ status: 403, description: '권한 없음' })
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: import('../auth/current-user.decorator').CurrentUserPayload,
  ) {
    await this.postsService.remove(id, user.id);
  }
}
