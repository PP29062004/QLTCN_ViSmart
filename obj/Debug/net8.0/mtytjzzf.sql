IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [AspNetRoles] (
    [Id] nvarchar(450) NOT NULL,
    [Name] nvarchar(256) NULL,
    [NormalizedName] nvarchar(256) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [AspNetUsers] (
    [Id] nvarchar(450) NOT NULL,
    [FullName] nvarchar(max) NOT NULL,
    [UserName] nvarchar(256) NULL,
    [NormalizedUserName] nvarchar(256) NULL,
    [Email] nvarchar(256) NULL,
    [NormalizedEmail] nvarchar(256) NULL,
    [EmailConfirmed] bit NOT NULL,
    [PasswordHash] nvarchar(max) NULL,
    [SecurityStamp] nvarchar(max) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    [PhoneNumber] nvarchar(max) NULL,
    [PhoneNumberConfirmed] bit NOT NULL,
    [TwoFactorEnabled] bit NOT NULL,
    [LockoutEnd] datetimeoffset NULL,
    [LockoutEnabled] bit NOT NULL,
    [AccessFailedCount] int NOT NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [LoaiDauTu] (
    [MaLoaiDauTu] int NOT NULL IDENTITY,
    [TenLoai] nvarchar(50) NOT NULL,
    CONSTRAINT [PK_LoaiDauTu] PRIMARY KEY ([MaLoaiDauTu])
);
GO

CREATE TABLE [NguoiDung] (
    [MaNguoiDung] nvarchar(450) NOT NULL,
    [TenDangNhap] nvarchar(50) NOT NULL,
    [HoTen] nvarchar(100) NOT NULL,
    [Email] nvarchar(100) NOT NULL,
    [NgayTao] datetime2 NOT NULL,
    CONSTRAINT [PK_NguoiDung] PRIMARY KEY ([MaNguoiDung])
);
GO

CREATE TABLE [AspNetRoleClaims] (
    [Id] int NOT NULL IDENTITY,
    [RoleId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [AspNetUserClaims] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [AspNetUserLogins] (
    [LoginProvider] nvarchar(450) NOT NULL,
    [ProviderKey] nvarchar(450) NOT NULL,
    [ProviderDisplayName] nvarchar(max) NULL,
    [UserId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [AspNetUserRoles] (
    [UserId] nvarchar(450) NOT NULL,
    [RoleId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
    CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [AspNetUserTokens] (
    [UserId] nvarchar(450) NOT NULL,
    [LoginProvider] nvarchar(450) NOT NULL,
    [Name] nvarchar(450) NOT NULL,
    [Value] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
    CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [DanhMuc] (
    [MaDanhMuc] int NOT NULL IDENTITY,
    [TenDanhMuc] nvarchar(50) NOT NULL,
    [Loai] nvarchar(10) NOT NULL,
    [NguoiDungId] nvarchar(450) NULL,
    CONSTRAINT [PK_DanhMuc] PRIMARY KEY ([MaDanhMuc]),
    CONSTRAINT [FK_DanhMuc_AspNetUsers_NguoiDungId] FOREIGN KEY ([NguoiDungId]) REFERENCES [AspNetUsers] ([Id])
);
GO

CREATE TABLE [DauTu] (
    [MaDauTu] int NOT NULL IDENTITY,
    [MaNguoiDung] nvarchar(450) NOT NULL,
    [MaLoaiDauTu] int NOT NULL,
    [GiaTri] decimal(15,2) NOT NULL,
    [GiaTriHienTai] decimal(15,2) NOT NULL,
    [Ngay] datetime2 NOT NULL,
    [NgayKetThuc] datetime2 NULL,
    [TrangThai] nvarchar(20) NOT NULL,
    [GhiChu] nvarchar(200) NOT NULL,
    [NguoiDungMaNguoiDung] nvarchar(450) NULL,
    CONSTRAINT [PK_DauTu] PRIMARY KEY ([MaDauTu]),
    CONSTRAINT [FK_DauTu_AspNetUsers_MaNguoiDung] FOREIGN KEY ([MaNguoiDung]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_DauTu_LoaiDauTu_MaLoaiDauTu] FOREIGN KEY ([MaLoaiDauTu]) REFERENCES [LoaiDauTu] ([MaLoaiDauTu]) ON DELETE NO ACTION,
    CONSTRAINT [FK_DauTu_NguoiDung_NguoiDungMaNguoiDung] FOREIGN KEY ([NguoiDungMaNguoiDung]) REFERENCES [NguoiDung] ([MaNguoiDung])
);
GO

CREATE TABLE [NoKhoanVay] (
    [MaNo] int NOT NULL IDENTITY,
    [MaNguoiDung] nvarchar(450) NOT NULL,
    [SoTien] decimal(15,2) NOT NULL,
    [LaiSuat] decimal(18,2) NOT NULL,
    [KyHan] int NOT NULL,
    [NgayBatDau] datetime2 NOT NULL,
    [NgayKetThuc] datetime2 NULL,
    [TrangThai] nvarchar(20) NOT NULL,
    [GhiChu] nvarchar(200) NOT NULL,
    [NgayTraTiepTheo] datetime2 NULL,
    [NguoiDungMaNguoiDung] nvarchar(450) NULL,
    CONSTRAINT [PK_NoKhoanVay] PRIMARY KEY ([MaNo]),
    CONSTRAINT [FK_NoKhoanVay_AspNetUsers_MaNguoiDung] FOREIGN KEY ([MaNguoiDung]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_NoKhoanVay_NguoiDung_NguoiDungMaNguoiDung] FOREIGN KEY ([NguoiDungMaNguoiDung]) REFERENCES [NguoiDung] ([MaNguoiDung])
);
GO

CREATE TABLE [TaiKhoan] (
    [MaTaiKhoan] int NOT NULL IDENTITY,
    [MaNguoiDung] nvarchar(450) NOT NULL,
    [TenTaiKhoan] nvarchar(50) NOT NULL,
    [SoDu] decimal(15,2) NOT NULL,
    [LoaiTaiKhoan] nvarchar(20) NOT NULL,
    [NgayTao] datetime2 NOT NULL,
    [NguoiDungMaNguoiDung] nvarchar(450) NULL,
    CONSTRAINT [PK_TaiKhoan] PRIMARY KEY ([MaTaiKhoan]),
    CONSTRAINT [FK_TaiKhoan_AspNetUsers_MaNguoiDung] FOREIGN KEY ([MaNguoiDung]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_TaiKhoan_NguoiDung_NguoiDungMaNguoiDung] FOREIGN KEY ([NguoiDungMaNguoiDung]) REFERENCES [NguoiDung] ([MaNguoiDung])
);
GO

CREATE TABLE [ThongBao] (
    [MaThongBao] int NOT NULL IDENTITY,
    [MaNguoiDung] nvarchar(450) NOT NULL,
    [NoiDung] nvarchar(500) NOT NULL,
    [Ngay] datetime2 NOT NULL,
    [DaDoc] bit NOT NULL,
    [Loai] nvarchar(20) NOT NULL,
    [MaLienKet] int NULL,
    [NguoiDungMaNguoiDung] nvarchar(450) NULL,
    CONSTRAINT [PK_ThongBao] PRIMARY KEY ([MaThongBao]),
    CONSTRAINT [FK_ThongBao_AspNetUsers_MaNguoiDung] FOREIGN KEY ([MaNguoiDung]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_ThongBao_NguoiDung_NguoiDungMaNguoiDung] FOREIGN KEY ([NguoiDungMaNguoiDung]) REFERENCES [NguoiDung] ([MaNguoiDung])
);
GO

CREATE TABLE [MucTieu] (
    [MaMucTieu] int NOT NULL IDENTITY,
    [MaNguoiDung] nvarchar(450) NOT NULL,
    [MaDanhMuc] int NOT NULL,
    [TenMucTieu] nvarchar(100) NOT NULL,
    [SoTienMucTieu] decimal(15,2) NOT NULL,
    [SoTienHienTai] decimal(15,2) NOT NULL,
    [HanChot] datetime2 NOT NULL,
    [TrangThai] nvarchar(20) NOT NULL,
    [GhiChu] nvarchar(200) NOT NULL,
    [NgayTao] datetime2 NOT NULL,
    [NguoiDungMaNguoiDung] nvarchar(450) NULL,
    CONSTRAINT [PK_MucTieu] PRIMARY KEY ([MaMucTieu]),
    CONSTRAINT [FK_MucTieu_AspNetUsers_MaNguoiDung] FOREIGN KEY ([MaNguoiDung]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_MucTieu_DanhMuc_MaDanhMuc] FOREIGN KEY ([MaDanhMuc]) REFERENCES [DanhMuc] ([MaDanhMuc]) ON DELETE NO ACTION,
    CONSTRAINT [FK_MucTieu_NguoiDung_NguoiDungMaNguoiDung] FOREIGN KEY ([NguoiDungMaNguoiDung]) REFERENCES [NguoiDung] ([MaNguoiDung])
);
GO

CREATE TABLE [LichSuTraNo] (
    [MaTraNo] int NOT NULL IDENTITY,
    [MaNo] int NOT NULL,
    [SoTienTra] decimal(15,2) NOT NULL,
    [NgayTra] datetime2 NOT NULL,
    [GhiChu] nvarchar(200) NOT NULL,
    CONSTRAINT [PK_LichSuTraNo] PRIMARY KEY ([MaTraNo]),
    CONSTRAINT [FK_LichSuTraNo_NoKhoanVay_MaNo] FOREIGN KEY ([MaNo]) REFERENCES [NoKhoanVay] ([MaNo]) ON DELETE CASCADE
);
GO

CREATE TABLE [GiaoDich] (
    [MaGiaoDich] int NOT NULL IDENTITY,
    [MaNguoiDung] nvarchar(450) NOT NULL,
    [MaTaiKhoan] int NOT NULL,
    [MaDanhMuc] int NOT NULL,
    [SoTien] decimal(15,2) NOT NULL,
    [LoaiGiaoDich] nvarchar(10) NOT NULL,
    [NgayGiaoDich] datetime2 NOT NULL,
    [GhiChu] nvarchar(200) NOT NULL,
    [DanhMucMaDanhMuc] int NULL,
    [NguoiDungMaNguoiDung] nvarchar(450) NULL,
    CONSTRAINT [PK_GiaoDich] PRIMARY KEY ([MaGiaoDich]),
    CONSTRAINT [FK_GiaoDich_AspNetUsers_MaNguoiDung] FOREIGN KEY ([MaNguoiDung]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION,
    CONSTRAINT [FK_GiaoDich_DanhMuc_DanhMucMaDanhMuc] FOREIGN KEY ([DanhMucMaDanhMuc]) REFERENCES [DanhMuc] ([MaDanhMuc]),
    CONSTRAINT [FK_GiaoDich_DanhMuc_MaDanhMuc] FOREIGN KEY ([MaDanhMuc]) REFERENCES [DanhMuc] ([MaDanhMuc]) ON DELETE CASCADE,
    CONSTRAINT [FK_GiaoDich_NguoiDung_NguoiDungMaNguoiDung] FOREIGN KEY ([NguoiDungMaNguoiDung]) REFERENCES [NguoiDung] ([MaNguoiDung]),
    CONSTRAINT [FK_GiaoDich_TaiKhoan_MaTaiKhoan] FOREIGN KEY ([MaTaiKhoan]) REFERENCES [TaiKhoan] ([MaTaiKhoan]) ON DELETE NO ACTION
);
GO

CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);
GO

CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL;
GO

CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);
GO

CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);
GO

CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);
GO

CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);
GO

CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL;
GO

CREATE INDEX [IX_DanhMuc_NguoiDungId] ON [DanhMuc] ([NguoiDungId]);
GO

CREATE INDEX [IX_DauTu_MaLoaiDauTu] ON [DauTu] ([MaLoaiDauTu]);
GO

CREATE INDEX [IX_DauTu_MaNguoiDung] ON [DauTu] ([MaNguoiDung]);
GO

CREATE INDEX [IX_DauTu_NguoiDungMaNguoiDung] ON [DauTu] ([NguoiDungMaNguoiDung]);
GO

CREATE INDEX [IX_GiaoDich_DanhMucMaDanhMuc] ON [GiaoDich] ([DanhMucMaDanhMuc]);
GO

CREATE INDEX [IX_GiaoDich_MaDanhMuc] ON [GiaoDich] ([MaDanhMuc]);
GO

CREATE INDEX [IX_GiaoDich_MaNguoiDung] ON [GiaoDich] ([MaNguoiDung]);
GO

CREATE INDEX [IX_GiaoDich_MaTaiKhoan] ON [GiaoDich] ([MaTaiKhoan]);
GO

CREATE INDEX [IX_GiaoDich_NguoiDungMaNguoiDung] ON [GiaoDich] ([NguoiDungMaNguoiDung]);
GO

CREATE INDEX [IX_LichSuTraNo_MaNo] ON [LichSuTraNo] ([MaNo]);
GO

CREATE INDEX [IX_MucTieu_MaDanhMuc] ON [MucTieu] ([MaDanhMuc]);
GO

CREATE INDEX [IX_MucTieu_MaNguoiDung] ON [MucTieu] ([MaNguoiDung]);
GO

CREATE INDEX [IX_MucTieu_NguoiDungMaNguoiDung] ON [MucTieu] ([NguoiDungMaNguoiDung]);
GO

CREATE INDEX [IX_NoKhoanVay_MaNguoiDung] ON [NoKhoanVay] ([MaNguoiDung]);
GO

CREATE INDEX [IX_NoKhoanVay_NguoiDungMaNguoiDung] ON [NoKhoanVay] ([NguoiDungMaNguoiDung]);
GO

CREATE INDEX [IX_TaiKhoan_MaNguoiDung] ON [TaiKhoan] ([MaNguoiDung]);
GO

CREATE INDEX [IX_TaiKhoan_NguoiDungMaNguoiDung] ON [TaiKhoan] ([NguoiDungMaNguoiDung]);
GO

CREATE INDEX [IX_ThongBao_MaNguoiDung] ON [ThongBao] ([MaNguoiDung]);
GO

CREATE INDEX [IX_ThongBao_NguoiDungMaNguoiDung] ON [ThongBao] ([NguoiDungMaNguoiDung]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250404101311_InitialCreate', N'8.0.14');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [BaoCao] (
    [MaBaoCao] int NOT NULL IDENTITY,
    [MaNguoiDung] nvarchar(450) NOT NULL,
    [Thang] int NOT NULL,
    [Nam] int NOT NULL,
    [TongThuNhap] decimal(15,2) NOT NULL DEFAULT 0.0,
    [TongChiTieu] decimal(15,2) NOT NULL DEFAULT 0.0,
    [SoTienTietKiem] decimal(15,2) NOT NULL DEFAULT 0.0,
    [GhiChu] nvarchar(200) NULL,
    [NgayTao] datetime NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT [PK_BaoCao] PRIMARY KEY ([MaBaoCao]),
    CONSTRAINT [FK_BaoCao_AspNetUsers_MaNguoiDung] FOREIGN KEY ([MaNguoiDung]) REFERENCES [AspNetUsers] ([Id]) ON DELETE NO ACTION
);
GO

CREATE INDEX [IX_BaoCao_MaNguoiDung] ON [BaoCao] ([MaNguoiDung]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250404102134_UpdateBaoCao', N'8.0.14');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250404154507_AddViewModels', N'8.0.14');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250405120753_AddVM', N'8.0.14');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

ALTER TABLE [AspNetUsers] ADD [SoDu] decimal(18,2) NOT NULL DEFAULT 0.0;
GO

ALTER TABLE [AspNetUsers] ADD [SurvivalMode] bit NOT NULL DEFAULT CAST(0 AS bit);
GO

ALTER TABLE [AspNetUsers] ADD [SurvivalModeStartDate] datetime2 NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20250407194902_UpdateAU', N'8.0.14');
GO

COMMIT;
GO

