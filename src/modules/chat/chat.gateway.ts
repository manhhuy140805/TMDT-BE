import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ChatService } from './chat.service';
import type { CreateMessageDto } from './dto';

@WebSocketGateway({
  cors: { origin: '*' },
  namespace: '/chat',
})
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  // Map userId -> Set of socket IDs
  private userSockets = new Map<number, Set<string>>();

  constructor(private readonly chatService: ChatService) {}

  // --- Connection lifecycle ---

  handleConnection(client: Socket): void {
    const userId = this.extractUserId(client);
    if (userId) {
      if (!this.userSockets.has(userId)) {
        this.userSockets.set(userId, new Set());
      }
      this.userSockets.get(userId)!.add(client.id);
      console.log(`[Chat WS] User ${userId} connected (socket: ${client.id})`);
    }
  }

  handleDisconnect(client: Socket): void {
    const userId = this.extractUserId(client);
    if (userId && this.userSockets.has(userId)) {
      this.userSockets.get(userId)!.delete(client.id);
      if (this.userSockets.get(userId)!.size === 0) {
        this.userSockets.delete(userId);
      }
      console.log(
        `[Chat WS] User ${userId} disconnected (socket: ${client.id})`,
      );
    }
  }

  // --- Events ---

  /**
   * Client joins a conversation room.
   * Emit: { cuocHoiThoaiId: number }
   */
  @SubscribeMessage('joinConversation')
  async handleJoinConversation(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { cuocHoiThoaiId: number },
  ): Promise<void> {
    try {
      const userId = this.requireSocketUserId(client);
      await this.chatService.assertUserCanAccessConversation(
        data.cuocHoiThoaiId,
        userId,
      );
      const room = `conversation_${data.cuocHoiThoaiId}`;
      client.join(room);
      console.log(`[Chat WS] Socket ${client.id} joined room ${room}`);
    } catch (error: any) {
      client.emit('error', {
        message: error.message || 'Failed to join conversation',
      });
    }
  }

  /**
   * Client leaves a conversation room.
   * Emit: { cuocHoiThoaiId: number }
   */
  @SubscribeMessage('leaveConversation')
  handleLeaveConversation(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { cuocHoiThoaiId: number },
  ): void {
    const room = `conversation_${data.cuocHoiThoaiId}`;
    client.leave(room);
    console.log(`[Chat WS] Socket ${client.id} left room ${room}`);
  }

  /**
   * Client sends a message via WebSocket.
   * Emit: { cuocHoiThoaiId, nguoiGuiId, noiDung, loaiTin? }
   * Server saves to DB then broadcasts to room.
   */
  @SubscribeMessage('sendMessage')
  async handleSendMessage(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: CreateMessageDto,
  ): Promise<void> {
    try {
      const userId = this.requireSocketUserId(client);
      if (userId !== data.nguoiGuiId) {
        throw new Error('Nguoi gui khong khop voi ket noi hien tai');
      }

      const result = await this.chatService.createMessage(data);

      // Broadcast to all clients in the conversation room
      const room = `conversation_${data.cuocHoiThoaiId}`;
      this.server.to(room).emit('newMessage', result.data);

      // Also notify the other member if they're not in the room
      // (for updating conversation list / unread count)
      const conversation = await this.chatService.findConversationById(
        data.cuocHoiThoaiId,
      );
      const recipientIds = [
        conversation.conversation.thanhVien1.taiKhoanId,
        conversation.conversation.thanhVien2.taiKhoanId,
        conversation.conversation.giamSat?.taiKhoanId,
      ].filter(
        (recipientId): recipientId is number =>
          recipientId !== undefined && recipientId !== data.nguoiGuiId,
      );

      for (const recipientId of new Set(recipientIds)) {
        this.emitToUser(recipientId, 'messageNotification', {
          cuocHoiThoaiId: data.cuocHoiThoaiId,
          message: result.data,
        });
      }
    } catch (error: any) {
      client.emit('error', {
        message: error.message || 'Failed to send message',
      });
    }
  }

  /**
   * Client marks messages as read.
   * Emit: { cuocHoiThoaiId, userId }
   */
  @SubscribeMessage('markAsRead')
  async handleMarkAsRead(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { cuocHoiThoaiId: number; userId: number },
  ): Promise<void> {
    try {
      const userId = this.requireSocketUserId(client);
      if (userId !== data.userId) {
        throw new Error('Nguoi dung khong khop voi ket noi hien tai');
      }
      await this.chatService.assertUserCanAccessConversation(
        data.cuocHoiThoaiId,
        userId,
      );
      const result = await this.chatService.markAsRead(
        data.cuocHoiThoaiId,
        data.userId,
      );

      // Notify the room that messages were read
      const room = `conversation_${data.cuocHoiThoaiId}`;
      this.server.to(room).emit('messagesRead', {
        cuocHoiThoaiId: data.cuocHoiThoaiId,
        userId: data.userId,
        count: result.count,
      });
    } catch (error: any) {
      client.emit('error', {
        message: error.message || 'Failed to mark as read',
      });
    }
  }

  /**
   * Typing indicator.
   * Emit: { cuocHoiThoaiId, userId, isTyping }
   */
  @SubscribeMessage('typing')
  handleTyping(
    @ConnectedSocket() client: Socket,
    @MessageBody()
    data: { cuocHoiThoaiId: number; userId: number; isTyping: boolean },
  ): void {
    const room = `conversation_${data.cuocHoiThoaiId}`;
    client.to(room).emit('userTyping', {
      cuocHoiThoaiId: data.cuocHoiThoaiId,
      userId: data.userId,
      isTyping: data.isTyping,
    });
  }

  // --- Helpers ---

  /**
   * Emit event to a specific user (all their connected sockets).
   */
  private emitToUser(userId: number, event: string, data: any): void {
    const sockets = this.userSockets.get(userId);
    if (sockets) {
      for (const socketId of sockets) {
        this.server.to(socketId).emit(event, data);
      }
    }
  }

  /**
   * Extract userId from socket handshake query.
   * Client connects with: io('/chat', { query: { userId: '1' } })
   */
  private extractUserId(client: Socket): number | null {
    const userId = client.handshake.query.userId;
    const parsed = parseInt(userId as string, 10);
    return isNaN(parsed) ? null : parsed;
  }

  private requireSocketUserId(client: Socket): number {
    const userId = this.extractUserId(client);
    if (!userId) {
      throw new Error('Ket noi chua co TaiKhoanID hop le');
    }
    return userId;
  }
}
