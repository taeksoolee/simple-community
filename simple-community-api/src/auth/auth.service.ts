import {
  Injectable,
  UnauthorizedException,
  ConflictException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
  ) {}

  async register(emailAddress: string, password: string) {
    const normalized = emailAddress.trim().toLowerCase();
    const existing = await this.prisma.user.findUnique({
      where: { emailAddress: normalized },
    });
    if (existing) {
      throw new ConflictException('이미 등록된 이메일입니다');
    }
    const passwordDigest = await bcrypt.hash(password, 10);
    const user = await this.prisma.user.create({
      data: {
        emailAddress: normalized,
        passwordDigest,
      },
    });
    return this.issueToken(user);
  }

  async login(emailAddress: string, password: string) {
    const normalized = emailAddress.trim().toLowerCase();
    const user = await this.prisma.user.findUnique({
      where: { emailAddress: normalized },
    });
    if (!user || !(await bcrypt.compare(password, user.passwordDigest))) {
      throw new UnauthorizedException('이메일 또는 비밀번호가 일치하지 않습니다');
    }
    return this.issueToken(user);
  }

  async validateUser(userId: number) {
    return this.prisma.user.findUnique({
      where: { id: userId },
      select: { id: true, emailAddress: true },
    });
  }

  private issueToken(user: { id: number; emailAddress: string }) {
    const payload = { sub: user.id, email: user.emailAddress };
    const accessToken = this.jwtService.sign(payload);
    return {
      accessToken,
      user: { id: user.id, emailAddress: user.emailAddress },
    };
  }
}
