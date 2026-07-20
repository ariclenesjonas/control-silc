-- Control SILC Database
-- Sistema Integrado de Gestão Escolar

CREATE DATABASE IF NOT EXISTS control_silc CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE control_silc;

-- ========================================
-- ROLES (Perfis de Usuário)
-- ========================================
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL COMMENT 'Nome do perfil',
    description TEXT COMMENT 'Descrição do perfil',
    slug VARCHAR(100) UNIQUE NOT NULL COMMENT 'Identificador único',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Ativo/Inativo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
    INDEX idx_slug (slug),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- PERMISSIONS (Permissões)
-- ========================================
CREATE TABLE permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL COMMENT 'Nome da permissão',
    description TEXT COMMENT 'Descrição',
    resource VARCHAR(100) NOT NULL COMMENT 'Recurso',
    action VARCHAR(50) NOT NULL COMMENT 'Ação (create, read, update, delete)',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Ativa/Inativa',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
    UNIQUE KEY unique_resource_action (resource, action),
    INDEX idx_resource (resource),
    INDEX idx_action (action)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- ROLE_PERMISSIONS (Relação entre Roles e Permissions)
-- ========================================
CREATE TABLE role_permissions (
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- USERS (Usuários do Sistema)
-- ========================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL COMMENT 'Email único',
    username VARCHAR(100) UNIQUE NOT NULL COMMENT 'Nome de usuário',
    password_hash VARCHAR(255) NOT NULL COMMENT 'Hash da senha',
    first_name VARCHAR(150) COMMENT 'Primeiro nome',
    last_name VARCHAR(150) COMMENT 'Sobrenome',
    profile_picture LONGTEXT COMMENT 'URL da foto de perfil',
    phone VARCHAR(20) COMMENT 'Telefone',
    cpf VARCHAR(11) UNIQUE COMMENT 'CPF',
    role_id INT NOT NULL COMMENT 'ID do perfil',
    institution_id INT COMMENT 'ID da instituição',
    status ENUM('active', 'inactive', 'suspended', 'deleted') DEFAULT 'active' COMMENT 'Status',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Ativo/Inativo',
    last_login TIMESTAMP NULL COMMENT 'Último login',
    login_attempts INT DEFAULT 0 COMMENT 'Tentativas de login falhadas',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
    deleted_at TIMESTAMP NULL COMMENT 'Data de exclusão lógica',
    FOREIGN KEY (role_id) REFERENCES roles(id),
    INDEX idx_email (email),
    INDEX idx_username (username),
    INDEX idx_cpf (cpf),
    INDEX idx_role_id (role_id),
    INDEX idx_status (status),
    INDEX idx_is_active (is_active),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- CLASSES (Turmas/Grupos)
-- ========================================
CREATE TABLE classes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT 'Nome da turma',
    code VARCHAR(50) UNIQUE NOT NULL COMMENT 'Código',
    level VARCHAR(50) NOT NULL COMMENT 'Nível (1º ano, 2º ano, etc)',
    year INT NOT NULL COMMENT 'Ano letivo',
    semester INT COMMENT 'Semestre',
    capacity INT DEFAULT 30 COMMENT 'Capacidade de alunos',
    description TEXT COMMENT 'Descrição',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Ativo/Inativo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
    deleted_at TIMESTAMP NULL COMMENT 'Data de exclusão lógica',
    INDEX idx_code (code),
    INDEX idx_year (year),
    INDEX idx_level (level),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- STUDENTS (Alunos)
-- ========================================
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE COMMENT 'ID do usuário',
    registration_number VARCHAR(50) UNIQUE NOT NULL COMMENT 'Número de matrícula',
    birth_date DATE NOT NULL COMMENT 'Data de nascimento',
    gender VARCHAR(20) COMMENT 'Gênero',
    address TEXT COMMENT 'Endereço',
    city VARCHAR(100) COMMENT 'Cidade',
    state VARCHAR(2) COMMENT 'Estado',
    zip_code VARCHAR(10) COMMENT 'CEP',
    guardian_name VARCHAR(200) COMMENT 'Nome do responsável',
    guardian_phone VARCHAR(20) COMMENT 'Telefone do responsável',
    guardian_email VARCHAR(255) COMMENT 'Email do responsável',
    class_id INT COMMENT 'ID da turma',
    status ENUM('active', 'inactive', 'graduated', 'transferred', 'expelled') DEFAULT 'active' COMMENT 'Status',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Ativo/Inativo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
    deleted_at TIMESTAMP NULL COMMENT 'Data de exclusão lógica',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    INDEX idx_registration_number (registration_number),
    INDEX idx_user_id (user_id),
    INDEX idx_class_id (class_id),
    INDEX idx_status (status),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- TEACHERS (Professores)
-- ========================================
CREATE TABLE teachers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE COMMENT 'ID do usuário',
    registration_number VARCHAR(50) UNIQUE NOT NULL COMMENT 'Número de registro',
    birth_date DATE NOT NULL COMMENT 'Data de nascimento',
    gender VARCHAR(20) COMMENT 'Gênero',
    specialization VARCHAR(200) COMMENT 'Especialização',
    degree VARCHAR(100) COMMENT 'Grau',
    hiring_date DATE NOT NULL COMMENT 'Data de contratação',
    salary VARCHAR(20) COMMENT 'Salário',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Ativo/Inativo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
    deleted_at TIMESTAMP NULL COMMENT 'Data de exclusão lógica',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_registration_number (registration_number),
    INDEX idx_user_id (user_id),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- DISCIPLINES (Disciplinas/Matérias)
-- ========================================
CREATE TABLE disciplines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL COMMENT 'Nome da disciplina',
    code VARCHAR(50) UNIQUE NOT NULL COMMENT 'Código',
    description TEXT COMMENT 'Descrição',
    workload INT NOT NULL COMMENT 'Carga horária em horas',
    credit_hours FLOAT COMMENT 'Créditos',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Ativo/Inativo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Data de criação',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Data de atualização',
    deleted_at TIMESTAMP NULL COMMENT 'Data de exclusão lógica',
    INDEX idx_code (code),
    INDEX idx_name (name),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- CLASS_DISCIPLINES (Disciplinas por Turma)
-- ========================================
CREATE TABLE class_disciplines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL COMMENT 'ID da turma',
    discipline_id INT NOT NULL COMMENT 'ID da disciplina',
    teacher_id INT COMMENT 'ID do professor',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_class_discipline (class_id, discipline_id),
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    FOREIGN KEY (discipline_id) REFERENCES disciplines(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- GRADES (Notas)
-- ========================================
CREATE TABLE grades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL COMMENT 'ID do aluno',
    class_discipline_id INT NOT NULL COMMENT 'ID da disciplina na turma',
    grade DECIMAL(5,2) COMMENT 'Nota (0-10)',
    weight INT DEFAULT 1 COMMENT 'Peso da nota',
    evaluation_type ENUM('exam', 'assignment', 'participation', 'project') COMMENT 'Tipo de avaliação',
    description TEXT COMMENT 'Descrição',
    recorded_by INT COMMENT 'ID do professor que registrou',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (class_discipline_id) REFERENCES class_disciplines(id) ON DELETE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES teachers(id) ON DELETE SET NULL,
    INDEX idx_student_id (student_id),
    INDEX idx_class_discipline_id (class_discipline_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- ATTENDANCE (Frequência)
-- ========================================
CREATE TABLE attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL COMMENT 'ID do aluno',
    class_discipline_id INT NOT NULL COMMENT 'ID da disciplina na turma',
    attendance_date DATE NOT NULL COMMENT 'Data da aula',
    status ENUM('present', 'absent', 'justified', 'late') DEFAULT 'present' COMMENT 'Status de presença',
    notes TEXT COMMENT 'Observações',
    recorded_by INT COMMENT 'ID do professor que registrou',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (class_discipline_id) REFERENCES class_disciplines(id) ON DELETE CASCADE,
    FOREIGN KEY (recorded_by) REFERENCES teachers(id) ON DELETE SET NULL,
    UNIQUE KEY unique_attendance (student_id, class_discipline_id, attendance_date),
    INDEX idx_student_id (student_id),
    INDEX idx_attendance_date (attendance_date),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- FINANCIAL (Financeiro)
-- ========================================
CREATE TABLE financial_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL COMMENT 'Descrição do item',
    type ENUM('tuition', 'fee', 'fine', 'discount') COMMENT 'Tipo de item',
    amount DECIMAL(10,2) NOT NULL COMMENT 'Valor',
    due_date DATE NOT NULL COMMENT 'Data de vencimento',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- STUDENT_FINANCIAL (Financeiro do Aluno)
-- ========================================
CREATE TABLE student_financial (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL COMMENT 'ID do aluno',
    financial_item_id INT NOT NULL COMMENT 'ID do item financeiro',
    year INT NOT NULL COMMENT 'Ano',
    month INT NOT NULL COMMENT 'Mês',
    amount_due DECIMAL(10,2) NOT NULL COMMENT 'Valor devido',
    amount_paid DECIMAL(10,2) DEFAULT 0 COMMENT 'Valor pago',
    status ENUM('pending', 'paid', 'overdue', 'cancelled') DEFAULT 'pending' COMMENT 'Status',
    payment_date DATE COMMENT 'Data do pagamento',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (financial_item_id) REFERENCES financial_items(id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_status (status),
    INDEX idx_year_month (year, month)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- BOOKS (Biblioteca - Livros)
-- ========================================
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT 'Título',
    author VARCHAR(255) NOT NULL COMMENT 'Autor',
    isbn VARCHAR(20) UNIQUE COMMENT 'ISBN',
    publisher VARCHAR(255) COMMENT 'Editora',
    publication_year INT COMMENT 'Ano de publicação',
    category VARCHAR(100) COMMENT 'Categoria',
    quantity INT DEFAULT 1 COMMENT 'Quantidade total',
    available_quantity INT DEFAULT 1 COMMENT 'Quantidade disponível',
    location VARCHAR(50) COMMENT 'Localização na biblioteca',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_title (title),
    INDEX idx_author (author),
    INDEX idx_isbn (isbn)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- BOOK_LOANS (Empréstimos de Livros)
-- ========================================
CREATE TABLE book_loans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL COMMENT 'ID do livro',
    student_id INT NOT NULL COMMENT 'ID do aluno',
    loan_date DATE NOT NULL COMMENT 'Data do empréstimo',
    return_date DATE COMMENT 'Data de devolução',
    expected_return_date DATE NOT NULL COMMENT 'Data esperada de devolução',
    status ENUM('active', 'returned', 'overdue') DEFAULT 'active' COMMENT 'Status',
    fine DECIMAL(10,2) DEFAULT 0 COMMENT 'Multa por atraso',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- ANNOUNCEMENTS (Avisos/Comunicados)
-- ========================================
CREATE TABLE announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT 'Título',
    content LONGTEXT NOT NULL COMMENT 'Conteúdo',
    created_by INT NOT NULL COMMENT 'ID do usuário que criou',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_created_at (created_at),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- MESSAGES (Mensagens entre Usuários)
-- ========================================
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL COMMENT 'ID do remetente',
    recipient_id INT NOT NULL COMMENT 'ID do destinatário',
    subject VARCHAR(255) COMMENT 'Assunto',
    content LONGTEXT NOT NULL COMMENT 'Conteúdo',
    is_read BOOLEAN DEFAULT FALSE COMMENT 'Lida/Não lida',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_recipient_id (recipient_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- AUDIT_LOGS (Log de Auditoria)
-- ========================================
CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT COMMENT 'ID do usuário',
    action VARCHAR(100) NOT NULL COMMENT 'Ação realizada',
    table_name VARCHAR(100) NOT NULL COMMENT 'Tabela afetada',
    record_id INT NOT NULL COMMENT 'ID do registro',
    old_values JSON COMMENT 'Valores antigos',
    new_values JSON COMMENT 'Valores novos',
    ip_address VARCHAR(45) COMMENT 'Endereço IP',
    user_agent TEXT COMMENT 'User Agent',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_table_name (table_name),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- INDEXES PARA PERFORMANCE
-- ========================================
CREATE INDEX idx_students_is_active ON students(is_active);
CREATE INDEX idx_teachers_is_active ON teachers(is_active);
CREATE INDEX idx_classes_is_active ON classes(is_active);
CREATE INDEX idx_disciplines_is_active ON disciplines(is_active);
