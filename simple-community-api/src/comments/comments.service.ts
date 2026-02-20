import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CommentsService {
  constructor(private prisma: PrismaService) {}

  async findByPost(postId: number, page = 1, perPage = 10) {
    const skip = (page - 1) * perPage;
    const [comments, total] = await Promise.all([
      this.prisma.comment.findMany({
        where: { postId, parentId: null },
        skip,
        take: perPage,
        orderBy: { createdAt: 'desc' },
        include: {
          user: { select: { id: true, emailAddress: true } },
          replies: {
            orderBy: { createdAt: 'asc' },
            include: {
              user: { select: { id: true, emailAddress: true } },
            },
          },
        },
      }),
      this.prisma.comment.count({ where: { postId, parentId: null } }),
    ]);
    return {
      items: comments,
      total,
      page,
      perPage,
      totalPages: Math.ceil(total / perPage),
    };
  }

  async create(
    postId: number,
    userId: number,
    body: string,
    parentId?: number,
  ) {
    const post = await this.prisma.post.findUnique({
      where: { id: postId },
    });
    if (!post) {
      throw new NotFoundException('게시글을 찾을 수 없습니다');
    }
    if (parentId) {
      const parent = await this.prisma.comment.findFirst({
        where: { id: parentId, postId },
      });
      if (!parent) {
        throw new NotFoundException('부모 댓글을 찾을 수 없습니다');
      }
    }
    return this.prisma.comment.create({
      data: {
        postId,
        userId,
        body,
        parentId: parentId ?? null,
      },
      include: {
        user: { select: { id: true, emailAddress: true } },
      },
    });
  }

  async remove(id: number, userId: number) {
    const comment = await this.prisma.comment.findUnique({
      where: { id },
    });
    if (!comment) {
      throw new NotFoundException('댓글을 찾을 수 없습니다');
    }
    if (comment.userId !== userId) {
      throw new ForbiddenException('삭제 권한이 없습니다');
    }
    await this.prisma.comment.delete({ where: { id } });
  }
}
