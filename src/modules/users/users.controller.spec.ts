import { beforeEach, describe, expect, it, jest } from '@jest/globals';
import { Test, TestingModule } from '@nestjs/testing';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';

describe('UsersController', () => {
  let usersController: UsersController;

  const usersServiceMock = {
    findAll: jest.fn(),
    search: jest.fn(),
    getProfile: jest.fn(),
    findOne: jest.fn(),
    update: jest.fn(),
    remove: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [UsersController],
      providers: [
        {
          provide: UsersService,
          useValue: usersServiceMock,
        },
      ],
    }).compile();

    usersController = module.get<UsersController>(UsersController);
    jest.clearAllMocks();
  });

  it('should call findAll from service', async () => {
    usersServiceMock.findAll.mockResolvedValue({ total: 0, users: [] });

    await usersController.findAll();

    expect(usersServiceMock.findAll).toHaveBeenCalledTimes(1);
  });

  it('should call search from service with query', async () => {
    const query = { keyword: 'john' };
    usersServiceMock.search.mockResolvedValue({ total: 0, users: [] });

    await usersController.search(query);

    expect(usersServiceMock.search).toHaveBeenCalledWith(query);
  });

  it('should call findOne from service with id', async () => {
    usersServiceMock.findOne.mockResolvedValue({
      user: {
        taiKhoanId: 1,
        tenDangNhap: 'john',
        email: 'john@example.com',
        hoTen: 'John',
        soDienThoai: null,
        gioiTinh: null,
        diaChi: null,
        vaiTro: 'NguoiThue',
        trangThai: 'HoatDong',
        ngayTao: new Date().toISOString(),
        ngayCapNhat: new Date().toISOString(),
      },
    });

    await usersController.findOne(1);

    expect(usersServiceMock.findOne).toHaveBeenCalledWith(1);
  });
});
