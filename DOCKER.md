# Control SILC - Docker Setup Guide

## Estrutura de Diretórios

```
control-silc/
├── backend/                 # FastAPI Backend
│   ├── app/
│   ├── requirements.txt
│   ├── main.py
│   └── Dockerfile
├── frontend/                # React Frontend
│   ├── src/
│   ├── package.json
│   ├── Dockerfile
│   └── nginx.conf
├── database/                # Banco de Dados
│   ├── init.sql            # Schema do banco
│   └── seeds.sql           # Dados iniciais
├── docker-compose.yml       # Orquestração
├── nginx.conf              # Configuração Nginx
└── README.md
```

## Serviços Docker

### 1. MySQL Database
- **Image**: mysql:8.0
- **Port**: 3306
- **User**: control_silc
- **Password**: control_silc_pass
- **Volume**: mysql_data (dados persistentes)

### 2. PHPMyAdmin
- **Image**: phpmyadmin:latest
- **Port**: 8080
- **Acesso**: http://localhost:8080

### 3. Backend FastAPI
- **Dockerfile**: backend/Dockerfile
- **Port**: 8000
- **Healthcheck**: Ativo
- **Reload**: Ativo (desenvolvimento)

### 4. Frontend React
- **Dockerfile**: frontend/Dockerfile
- **Port**: 3000
- **Build**: Multi-stage (otimizado)

### 5. Nginx
- **Image**: nginx:alpine
- **Port**: 80 (HTTP)
- **Proxy**: Backend e Frontend

## Variáveis de Ambiente

### Backend
```
DEBUG=true
DATABASE_URL=mysql+pymysql://control_silc:control_silc_pass@mysql:3306/control_silc
SECRET_KEY=your-secret-key
ACCESS_TOKEN_EXPIRE_MINUTES=15
CORS_ORIGINS=["http://localhost:3000", "http://localhost:5173"]
```

### Frontend
```
REACT_APP_API_URL=http://localhost:8000/api/v1
```

## Networks

Todos os serviços usam a rede Docker `control-silc-network` para comunicação interna.

## Volumes

- `mysql_data`: Dados persistentes do MySQL
- Montagens de bind para desenvolvimento

## Health Checks

MySQL:
```bash
mysqladmin ping -h localhost
```

## Inicialização do Banco

1. `database/init.sql` - Schema completo
2. `database/seeds.sql` - Dados iniciais

Ambos executados automaticamente ao iniciar o MySQL.
