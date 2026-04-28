import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
} from '@nestjs/common';
import { ChatService } from './chat.service';
import type {
  ConversationListResponseDto,
  ConversationMutationResponseDto,
  ConversationResponseDto,
  CreateConversationDto,
  CreateMessageDto,
  MessageListResponseDto,
  MessageMutationResponseDto,
} from './dto';

@Controller()
export class ChatController {
  constructor(private readonly chatService: ChatService) {}

  @Post('conversations')
  createConversation(
    @Body() payload: CreateConversationDto,
  ): Promise<ConversationMutationResponseDto> {
    return this.chatService.createConversation(payload);
  }

  @Get('conversations/:id')
  findConversation(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ConversationResponseDto> {
    return this.chatService.findConversationById(id);
  }

  @Get('contracts/:id/conversations')
  findConversationsByContract(
    @Param('id', ParseIntPipe) contractId: number,
  ): Promise<ConversationListResponseDto> {
    return this.chatService.findConversationsByContractId(contractId);
  }

  @Post('messages')
  createMessage(
    @Body() payload: CreateMessageDto,
  ): Promise<MessageMutationResponseDto> {
    return this.chatService.createMessage(payload);
  }

  @Get('conversations/:id/messages')
  getMessages(
    @Param('id', ParseIntPipe) conversationId: number,
  ): Promise<MessageListResponseDto> {
    return this.chatService.getMessages(conversationId);
  }
}
