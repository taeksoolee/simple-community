import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtStrategy } from './jwt.strategy';

const DEV_SECRET = 'dev-secret-change-in-production';
const jwtSecret = process.env.JWT_SECRET || DEV_SECRET;
if (process.env.NODE_ENV === 'production' && jwtSecret === DEV_SECRET) {
  throw new Error(
    'JWT_SECRET must be set in production. Do not use the default dev secret.',
  );
}

@Module({
  imports: [
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.register({
      secret: jwtSecret,
      signOptions: { expiresIn: '7d' },
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
  exports: [AuthService],
})
export class AuthModule {}
