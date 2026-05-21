import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Post,
  Put,
} from '@nestjs/common';
import { ContractsService } from './contracts.service';
import { ContractFlowService } from './contract-flow.service';
import { ProgressService } from '../progress/progress.service';
import { ChatService } from '../chat/chat.service';
import type {
  ContractMutationResponseDto,
  ContractResponseDto,
  ContractsListResponseDto,
  CreateContractDto,
  SelectSupervisorDto,
  SupervisorResponseDto,
  UpdateContractStatusDto,
} from './dto/contract.dto';
import type {
  AcceptProposalDto,
  AcceptProposalResponseDto,
  ConfirmCompletionDto,
  ConfirmCompletionResponseDto,
} from './dto/accept-proposal.dto';
import type { ProgressListResponseDto } from '../progress/dto/progress.dto';
import type { ConversationListResponseDto } from '../chat/dto';

@Controller('contracts')
export class ContractsController {
  constructor(
    private readonly contractsService: ContractsService,
    private readonly contractFlowService: ContractFlowService,
    private readonly progressService: ProgressService,
    private readonly chatService: ChatService,
  ) {}

  @Get()
  findAll(): Promise<ContractsListResponseDto> {
    return this.contractsService.findAll();
  }

  @Get(':id')
  findOne(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ContractResponseDto> {
    return this.contractsService.findOne(id);
  }

  @Get(':id/detail')
  getDetail(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ContractResponseDto> {
    return this.contractsService.getDetail(id);
  }

  @Get(':id/progress')
  getProgress(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ProgressListResponseDto> {
    return this.progressService.findByContractId(id);
  }

  @Get(':id/conversations')
  getConversations(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<ConversationListResponseDto> {
    return this.chatService.findConversationsByContractId(id);
  }

  @Post()
  create(
    @Body() payload: CreateContractDto,
  ): Promise<ContractMutationResponseDto> {
    return this.contractsService.create(payload);
  }

  @Put(':id/status')
  updateStatus(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: UpdateContractStatusDto,
  ): Promise<ContractMutationResponseDto> {
    return this.contractsService.updateStatus(id, payload);
  }

  @Post(':id/supervisor')
  selectSupervisor(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: SelectSupervisorDto,
  ): Promise<SupervisorResponseDto> {
    return this.contractsService.selectSupervisor(id, payload);
  }

  @Put(':id/supervisor/accept')
  acceptSupervisor(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<SupervisorResponseDto> {
    return this.contractsService.acceptSupervisor(id);
  }

  @Put(':id/supervisor/reject')
  rejectSupervisor(
    @Param('id', ParseIntPipe) id: number,
  ): Promise<SupervisorResponseDto> {
    return this.contractsService.rejectSupervisor(id);
  }

  // --- Contract Flow: Accept Proposal + Escrow + Confirm Completion ---

  @Post('accept-proposal')
  acceptProposal(
    @Body() payload: AcceptProposalDto,
  ): Promise<AcceptProposalResponseDto> {
    return this.contractFlowService.acceptProposal(payload);
  }

  @Put(':id/confirm-completion')
  confirmCompletion(
    @Param('id', ParseIntPipe) id: number,
    @Body() payload: Omit<ConfirmCompletionDto, 'congViecId'>,
  ): Promise<ConfirmCompletionResponseDto> {
    return this.contractFlowService.confirmCompletion({
      ...payload,
      congViecId: id,
    });
  }
}
