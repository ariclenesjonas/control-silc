# Control SILC — Sistema Integrado de Gestão Escolar

## 🎓 Sobre o Projeto

O **Control SILC** é um ERP profissional, moderno e seguro para gestão educacional completa.

### Características Principais

- ✅ Gestão Administrativa (Alunos, Professores, Funcionários)
- ✅ Gestão Acadêmica (Turmas, Disciplinas, Horários)
- ✅ Gestão Financeira (Mensalidades, Pagamentos, Recibos)
- ✅ Gestão Pedagógica (Notas, Frequência, Avaliações)
- ✅ Comunicação Escolar (Mensagens, Notificações)
- ✅ Biblioteca (Livros, Empréstimos)
- ✅ Relatórios (PDF, Excel)
- ✅ Dashboard Interativo
- ✅ Autenticação Segura (JWT + RBAC)
- ✅ Responsividade Completa
- ✅ Tema Claro/Escuro

## 🛠️ Tecnologias

### Backend
- Python 3.11+
- FastAPI
- SQLAlchemy
- Pydantic
- Alembic
- JWT (PyJWT)

### Frontend
- React 18+
- Vite
- TypeScript
- Tailwind CSS
- Framer Motion
- React Hook Form
- Axios

### Banco de Dados
- MySQL 8.0+
- phpMyAdmin

### Infraestrutura
- Docker
- Docker Compose
- Nginx

## 🚀 Quick Start

### Pré-requisitos
- Docker
- Docker Compose

### Instalação

```bash
git clone https://github.com/ariclenesjonas/control-silc.git
cd control-silc

docker-compose up -d
```

### Acesso

- **Frontend**: http://localhost:3000
- **Backend (Swagger)**: http://localhost:8000/docs
- **phpMyAdmin**: http://localhost:8080

### Credenciais Padrão

- **Usuário**: admin@control-silc.com
- **Senha**: Control@123
- **Perfil**: Administrador Geral

## 📁 Estrutura do Projeto

```
control-silc/
├── backend/                    # API FastAPI
│   ├── app/
│   │   ├── core/              # Configurações
│   │   ├── database/          # Conexão e modelos
│   │   ├── models/            # SQLAlchemy ORM
│   │   ├── schemas/           # Pydantic schemas
│   │   ├── routers/           # Endpoints
│   │   ├── services/          # Lógica de negócio
│   │   ├── repositories/      # Acesso a dados
│   │   ├── middlewares/       # Autenticação, CORS
│   │   └── utils/             # Utilitários
│   ├── migrations/            # Alembic migrations
│   ├── tests/
│   ├── requirements.txt
│   ├── main.py
│   └── Dockerfile
├── frontend/                   # React + Vite
│   ├── src/
│   │   ├── components/        # Componentes
│   │   ├── pages/             # Páginas
│   │   ├── hooks/             # Custom hooks
│   │   ├── services/          # API calls
│   │   ├── context/           # Context API
│   │   ├── styles/            # CSS global
│   │   ├── utils/             # Utilitários
│   │   └── App.tsx
│   ├── public/
│   ├── package.json
│   ├── vite.config.ts
│   └── Dockerfile
├── database/
│   ├── init.sql               # Schema inicial
│   └── seeds.sql              # Dados padrão
├── docker-compose.yml
└── README.md
```

## 📚 Documentação

Todos os endpoints estão documentados no Swagger:
```
http://localhost:8000/docs
```

## 🔐 Autenticação

O sistema utiliza JWT com Refresh Token para segurança.

### Flow de Autenticação

1. Usuário faz login com email/senha
2. Sistema retorna `access_token` + `refresh_token`
3. `access_token` válido por 15 minutos
4. `refresh_token` válido por 7 dias
5. Ao expirar, solicitar novo `access_token` com `refresh_token`

## 👥 Perfis de Acesso

1. **Administrador Geral** - Acesso total ao sistema
2. **Diretor** - Gestão completa da instituição
3. **Subdiretor** - Gestão administrativo-pedagógica
4. **Coordenador** - Gestão de cursos e turmas
5. **Secretário** - Gestão de documentos e matrículas
6. **Tesoureiro** - Gestão financeira
7. **Professor** - Lançamento de notas e presença
8. **Bibliotecário** - Gestão da biblioteca
9. **Aluno** - Consulta de notas e documentos
10. **Encarregado de Educação** - Acompanhamento do aluno

## 📊 Módulos

- **Administrativo**: Usuários, Instituições, Funcionários
- **Acadêmico**: Alunos, Cursos, Turmas, Disciplinas
- **Pedagógico**: Notas, Frequência, Avaliações
- **Financeiro**: Mensalidades, Pagamentos, Recibos
- **Biblioteca**: Livros, Empréstimos, Devoluções
- **Comunicação**: Mensagens, Notificações

## 🧪 Testes

```bash
cd backend
pip install -r requirements-dev.txt
pytest
```

## 📝 Licença

MIT License

## 👨‍💻 Desenvolvimento

Desenvolvido por equipe multidisciplinar de especialistas em:
- Engenharia de Software
- Arquitetura de Sistemas
- Backend (FastAPI)
- Frontend (React)
- DevOps
- Segurança
- UX/UI Design
