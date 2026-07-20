# Control SILC — Sistema Integrado de Gestão Escolar

## 🚀 Início Rápido com Docker Compose

### Pré-requisitos
- Docker
- Docker Compose

### 1. Clonar o Repositório

```bash
git clone https://github.com/ariclenesjonas/control-silc.git
cd control-silc
```

### 2. Iniciar os Serviços

```bash
docker-compose up -d
```

### 3. Aguardar Inicialização

Aguarde cerca de 30 segundos para todos os serviços iniciarem.

### 4. Acessar o Sistema

- **Frontend**: http://localhost:3000
- **Backend (Swagger)**: http://localhost:8000/docs
- **phpMyAdmin**: http://localhost:8080
- **API Direct**: http://localhost:8000/api/v1

### 5. Credenciais Padrão

- **Email**: admin@control-silc.com
- **Senha**: Control@123
- **Perfil**: Administrador Geral

### 6. Banco de Dados (phpMyAdmin)

- **Host**: localhost:8080
- **Usuário**: root
- **Senha**: root
- **Banco**: control_silc

## 📋 Estrutura dos Serviços

### MySQL (3306)
- Banco de dados relacional
- Dados persistentes em volume Docker
- Backup em `database/init.sql` e `database/seeds.sql`

### PHPMyAdmin (8080)
- Interface web para gerenciar MySQL
- Acesso ao banco de dados

### Backend FastAPI (8000)
- API REST completa
- Swagger em `/docs`
- ReDoc em `/redoc`

### Frontend React (3000)
- Interface moderna com Tailwind CSS
- Comunicação com API
- Autenticação JWT

### Nginx (80)
- Proxy reverso
- Roteamento de requisições
- Compressão GZIP

## 🛠️ Comandos Úteis

### Parar os Serviços

```bash
docker-compose down
```

### Ver Logs

```bash
docker-compose logs -f [service]
# Ex: docker-compose logs -f backend
```

### Acessar Terminal do Container

```bash
docker-compose exec [service] bash
# Ex: docker-compose exec backend bash
```

### Reconstruir Imagens

```bash
docker-compose up -d --build
```

### Limpar Volumes (Cuidado: Remove dados!)

```bash
docker-compose down -v
```

## 📊 Diagrama de Arquitetura

```
┌─────────────────────────────────────────────────┐
│              Internet / Browser                 │
└──────────────────────┬──────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────┐
│          Nginx (Port 80)                        │
│     Proxy Reverso & Roteamento                  │
└──────┬────────────────────────┬─────────────────┘
       │                        │
  ┌────▼────┐           ┌──────▼──────┐
  │ Frontend │           │   Backend   │
  │ React    │           │   FastAPI   │
  │ (3000)   │           │   (8000)    │
  └────▼────┘           └──────┬──────┘
       │                        │
       │                        │
       └────────────┬───────────┘
                    │
           ┌────────▼────────┐
           │  MySQL (3306)   │
           │  PHPMyAdmin     │
           │  (8080)         │
           └─────────────────┘
```

## 🔐 Segurança em Produção

### Trocar Variáveis de Ambiente

1. Copiar `.env.example` para `.env`
2. Alterar valores sensíveis
3. **NUNCA** fazer commit de `.env`

### Trocar Senha do MySQL

Em `docker-compose.yml`, alterar:
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_PASSWORD`

### Trocar SECRET_KEY JWT

Gerar nova chave:
```bash
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

Alterar em `docker-compose.yml`:
```yaml
SECRET_KEY: "sua-nova-chave-aqui"
```

## 🐛 Troubleshooting

### Porta Já em Uso

```bash
# Encontrar processo usando porta
lsof -i :3000

# Matar processo
kill -9 [PID]
```

### Conectar ao MySQL Localmente

```bash
mysql -h 127.0.0.1 -u root -p control_silc
# Senha: root
```

### Backend Não Conecta ao MySQL

```bash
# Verificar saúde do MySQL
docker-compose exec mysql mysqladmin ping -h localhost
```

### Frontend Não Conecta ao Backend

1. Verificar se backend está rodando: `docker-compose logs backend`
2. Verificar CORS no backend
3. Limpar cache do navegador

## 📝 Próximos Passos

1. **Customizar Temas**: Editar cores em `frontend/tailwind.config.js`
2. **Adicionar Módulos**: Criar novos routers no `backend/app/routers/`
3. **Deploy em Produção**: Usar Docker Swarm ou Kubernetes
4. **Configurar SSL**: Adicionar certificados em `certs/`
5. **Backup Automático**: Configurar script de backup do MySQL

## 📚 Documentação Adicional

- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [React Docs](https://react.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
- [MySQL Docs](https://dev.mysql.com/doc/)
- [Docker Compose Docs](https://docs.docker.com/compose/)

## 💡 Contribuindo

1. Fazer fork do projeto
2. Criar branch para feature (`git checkout -b feature/AmazingFeature`)
3. Commit das mudanças (`git commit -m 'Add AmazingFeature'`)
4. Push para branch (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📧 Suporte

Para dúvidas ou problemas, abra uma issue no repositório.

## 📄 Licença

MIT License - veja arquivo `LICENSE` para detalhes.
