import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { ChatService } from './chat.service';
import type {
  CloseConversationResponseDto,
  ConversationMutationResponseDto,
  ConversationResponseDto,
  CreateConversationDto,
  CreateMessageDto,
  MarkReadResponseDto,
  MessageListResponseDto,
  MessageMutationResponseDto,
} from './dto';

@Controller('chat')
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  // POST /conversations
  @Post()
  create(
    @Body() payload: CreateConversationDto,
  ): Promise<ConversationMutationResponseDto> {
    return this.chatService.createConversation(payload);
  }

  // GET /conversations/:id
  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ConversationResponseDto> {
    return this.chatService.findConversationById(id);
  }

  // PUT /conversations/:id/close
  @Put(':id/close')
  close(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<CloseConversationResponseDto> {
    return this.chatService.closeConversation(id);
  }

  // GET /conversations/:id/messages
  @Get(':id/messages')
  getMessages(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<MessageListResponseDto> {
    return this.chatService.getMessages(id);
  }

  // POST /conversations/:id/messages
  @Post(':id/messages')
  sendMessage(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: CreateMessageDto,
  ): Promise<MessageMutationResponseDto> {
    return this.chatService.createMessage({ ...payload, cuocHoiThoaiId: id });
  }

  // PUT /conversations/:id/read/:userId
  @Put(':id/read/:userId')
  markAsRead(
    @Param('id', ParseIntPipe) id: number,
    @Param('userId', ParseIntPipe) userId: number,
  ): Promise<MarkReadResponseDto> {
    return this.chatService.markAsRead(id, userId);
  }
}
