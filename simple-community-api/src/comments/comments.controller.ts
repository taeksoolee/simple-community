import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Param,
  Query,
  ParseIntPipe,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { CommentsService } from './comments.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { CurrentUser } from '../auth/current-user.decorator';
import { Public } from '../auth/public.decorator';

@ApiTags('댓글')
@Controller('posts/:postId/comments')
export class CommentsController {
  constructor(private commentsService: CommentsService) {}

  @Get()
  @Public()
  @ApiOperation({ summary: '댓글 목록 (페이지네이션)' })
  @ApiResponse({ status: 200, description: '성공' })
  async findAll(
    @Param('postId', ParseIntPipe) postId: number,
    @Query('page') page?: string,
    @Query('perPage') perPage?: string,
  ) {
    const pageNum = page ? parseInt(page, 10) : 1;
    const perPageNum = perPage ? parseInt(perPage, 10) : 10;
    return this.commentsService.findByPost(postId, pageNum, perPageNum);
  }

  @Post()
  @ApiBearerAuth()
  @ApiOperation({ summary: '댓글 작성' })
  @ApiResponse({ status: 201, description: '작성됨' })
  async create(
    @Param('postId', ParseIntPipe) postId: number,
    @CurrentUser() user: import('../auth/current-user.decorator').CurrentUserPayload,
    @Body() dto: CreateCommentDto,
  ) {
    return this.commentsService.create(
      postId,
      user.id,
      dto.body,
      dto.parentId,
    );
  }

  @Delete(':id')
  @ApiOperation({ summary: '댓글 삭제' })
  @ApiResponse({ status: 200, description: '삭제됨' })
  @ApiResponse({ status: 403, description: '권한 없음' })
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: import('../auth/current-user.decorator').CurrentUserPayload,
  ) {
    await this.commentsService.remove(id, user.id);
  }
}
