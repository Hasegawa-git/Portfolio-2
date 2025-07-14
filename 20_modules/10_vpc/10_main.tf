# AWS VPC Module - main.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. VPC 本体
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc" 
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. インターネットゲートウェイ (IGW)
#    - パブリックサブネットからのインターネットアクセスを許可
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. NATゲートウェイ (NAT GW)
#    - プライベートサブネットからのインターネットアクセスを許可 (VPCエンドポイントを除く)
#    - EIP (Elastic IP) が必要
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_eip" "nat_gateway_eip" {
  vpc = true # VPC環境用

  tags = {
    Name        = "${var.project_name}-nat-gateway-eip"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.public[0].id # 最初のパブリックサブネットに配置

  tags = {
    Name        = "${var.project_name}-nat-gateway"
    Environment = var.environment
  }
  # NAT Gatewayは、Elastic IPとサブネットが作成された後に作成されることを保証
  depends_on = [aws_internet_gateway.main] # IGWも依存関係に追加
}

# ----------------------------------------------------------------------------------------------------------------------
# 4. サブネット
#    - パブリックサブネットとプライベートサブネットをそれぞれ複数作成
#    - var.azs (利用可能ゾーン) の数だけ作成
# ----------------------------------------------------------------------------------------------------------------------

# パブリックサブネット
resource "aws_subnet" "public" {
  count             = length(var.azs) # AZの数だけ作成
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, var.subnet_newbits, count.index + var.public_subnet_offset) # 例: 10.0.0.0/24, 10.0.1.0/24 ...
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true # パブリックサブネットは起動時にパブリックIPを自動割り当て

  tags = {
    Name        = "${var.project_name}-public-subnet-${var.azs[count.index]}" # AZ名をサブネット名に含める
    Environment = var.environment
  }
}

# プライベートサブネット
resource "aws_subnet" "private" {
  count             = length(var.azs) # AZの数だけ作成
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, var.subnet_newbits, count.index + var.private_subnet_offset) # 例: 10.0.2.0/24, 10.0.3.0/24 ...
  availability_zone = var.azs[count.index]

  tags = {
    Name        = "${var.project_name}-private-subnet-${var.azs[count.index]}" # AZ名をサブネット名に含める
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# 5. ルートテーブル
#    - パブリックルートテーブルとプライベートルートテーブル
# ----------------------------------------------------------------------------------------------------------------------

# パブリックルートテーブル
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-public-rtb"
    Environment = var.environment
  }
}

# パブリックルートテーブルへのインターネットゲートウェイのルート追加
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# パブリックサブネットとパブリックルートテーブルの関連付け
resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# プライベートルートテーブル (各AZに1つ作成)
resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-private-rtb-${var.azs[count.index]}" # AZ名をルートテーブル名に含める
    Environment = var.environment
  }
}

# プライベートルートテーブルへのNATゲートウェイのルート追加
resource "aws_route" "private_nat_gateway" {
  count                  = length(var.azs)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

# プライベートサブネットとプライベートルートテーブルの関連付け
resource "aws_route_table_association" "private" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}