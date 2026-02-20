import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class PostsService {
  constructor(private prisma: PrismaService) {}

  async findAll(page = 1, perPage = 10) {
    const skip = (page - 1) * perPage;
    const [posts, total] = await Promise.all([
      this.prisma.post.findMany({
        skip,
        take: perPage,
        orderBy: { createdAt: 'desc' },
        include: {
          user: {
            select: { id: true, emailAddress: true },
          },
        },
      }),
      this.prisma.post.count(),
    ]);
    return {
      items: posts,
      total,
      page,
      perPage,
      totalPages: Math.ceil(total / perPage),
    };
  }

  async findOne(id: number) {
    const post = await this.prisma.post.findUnique({
      where: { id },
      include: {
        user: {
          select: { id: true, emailAddress: true },
        },
      },
    });
    if (!post) {
      throw new NotFoundException('게시글을 찾을 수 없습니다');
    }
    return post;
  }

  async create(userId: number, data: { title: string; body: string }) {
    return this.prisma.post.create({
      data: {
        ...data,
        userId,
      },
      include: {
        user: {
          select: { id: true, emailAddress: true },
        },
      },
    });
  }

  async update(id: number, userId: number, data: { title?: string; body?: string }) {
    const post = await this.findOne(id);
    if (post.userId !== userId) {
      throw new ForbiddenException('수정 권한이 없습니다');
    }
    return this.prisma.post.update({
      where: { id },
      data,
      include: {
        user: {
          select: { id: true, emailAddress: true },
        },
      },
    });
  }

  async remove(id: number, userId: number) {
    const post = await this.findOne(id);
    if (post.userId !== userId) {
      throw new ForbiddenException('삭제 권한이 없습니다');
    }
    await this.prisma.post.delete({ where: { id } });
  }
}
