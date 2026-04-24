import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import type { AuthLoginDto, AuthRegisterDto, AuthResponseDto } from './dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  register(@Body() payload: AuthRegisterDto): Promise<AuthResponseDto> {
    return this.authService.register(payload);
  }

  @Post('login')
  login(@Body() payload: AuthLoginDto): Promise<AuthResponseDto> {
    return this.authService.login(payload);
  }
}
