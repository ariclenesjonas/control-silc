-- Dados padrão para o sistema
USE control_silc;

-- ========================================
-- INSERIR ROLES (PERFIS)
-- ========================================
INSERT INTO roles (name, slug, description, is_active) VALUES
('Administrador Geral', 'admin', 'Acesso completo ao sistema', TRUE),
('Diretor', 'director', 'Gerenciamento completo da instituição', TRUE),
('Subdiretor', 'subdirector', 'Gerenciamento administrativo e pedagógico', TRUE),
('Coordenador', 'coordinator', 'Gerenciamento de cursos e turmas', TRUE),
('Secretário', 'secretary', 'Gerenciamento de documentos e matrículas', TRUE),
('Tesoureiro', 'treasurer', 'Gerenciamento financeiro', TRUE),
('Professor', 'teacher', 'Lançamento de notas e presença', TRUE),
('Bibliotecário', 'librarian', 'Gerenciamento da biblioteca', TRUE),
('Aluno', 'student', 'Consulta de notas e documentos', TRUE),
('Encarregado de Educação', 'guardian', 'Acompanhamento do aluno', TRUE);

-- ========================================
-- INSERIR PERMISSIONS (PERMISSÕES)
-- ========================================
INSERT INTO permissions (name, resource, action, description, is_active) VALUES
('Criar Usuário', 'users', 'create', 'Pode criar novos usuários', TRUE),
('Ler Usuário', 'users', 'read', 'Pode visualizar usuários', TRUE),
('Atualizar Usuário', 'users', 'update', 'Pode editar usuários', TRUE),
('Deletar Usuário', 'users', 'delete', 'Pode deletar usuários', TRUE),
('Criar Aluno', 'students', 'create', 'Pode criar novos alunos', TRUE),
('Ler Aluno', 'students', 'read', 'Pode visualizar alunos', TRUE),
('Atualizar Aluno', 'students', 'update', 'Pode editar alunos', TRUE),
('Deletar Aluno', 'students', 'delete', 'Pode deletar alunos', TRUE),
('Criar Turma', 'classes', 'create', 'Pode criar novas turmas', TRUE),
('Ler Turma', 'classes', 'read', 'Pode visualizar turmas', TRUE),
('Atualizar Turma', 'classes', 'update', 'Pode editar turmas', TRUE),
('Deletar Turma', 'classes', 'delete', 'Pode deletar turmas', TRUE),
('Registrar Notas', 'grades', 'create', 'Pode registrar notas', TRUE),
('Registrar Presença', 'attendance', 'create', 'Pode registrar presença', TRUE),
('Gerenciar Financeiro', 'financial', 'create', 'Pode gerenciar financeiro', TRUE);

-- ========================================
-- ATRIBUIR PERMISSÕES AOS ROLES
-- ========================================
-- Admin tem todas as permissões
INSERT INTO role_permissions (role_id, permission_id)
SELECT 1, id FROM permissions;

-- Director
INSERT INTO role_permissions (role_id, permission_id)
SELECT 2, id FROM permissions WHERE resource IN ('students', 'classes', 'teachers', 'disciplines', 'financial');

-- Teacher pode registrar notas e presença
INSERT INTO role_permissions (role_id, permission_id)
SELECT 7, id FROM permissions WHERE resource IN ('grades', 'attendance') AND action IN ('create', 'read', 'update');

-- Student pode ler suas informações
INSERT INTO role_permissions (role_id, permission_id)
SELECT 9, id FROM permissions WHERE resource IN ('students', 'grades', 'attendance') AND action = 'read';

-- ========================================
-- INSERIR USUÁRIO ADMIN PADRÃO
-- ========================================
INSERT INTO users (email, username, password_hash, first_name, last_name, role_id, status, is_active) 
VALUES (
    'admin@control-silc.com',
    'admin',
    '$2b$12$R9Nn0sLKzSTRcfcLVdMhb.AJ9v0EHbKQgRVy8HQ6zHrmUFZjLqHwK', -- Control@123
    'Administrador',
    'Sistema',
    1,
    'active',
    TRUE
);

-- ========================================
-- INSERIR DISCIPLINAS PADRÃO
-- ========================================
INSERT INTO disciplines (name, code, workload, description, is_active) VALUES
('Português', 'PORT', 80, 'Disciplina de Linguagem Portuguesa', TRUE),
('Matemática', 'MAT', 80, 'Disciplina de Matemática', TRUE),
('História', 'HIST', 60, 'Disciplina de História', TRUE),
('Geografia', 'GEO', 60, 'Disciplina de Geografia', TRUE),
('Ciências', 'CIENC', 80, 'Disciplina de Ciências', TRUE),
('Educação Física', 'EDFIS', 60, 'Disciplina de Educação Física', TRUE),
('Arte', 'ARTE', 40, 'Disciplina de Arte', TRUE),
('Inglês', 'ENG', 60, 'Disciplina de Língua Inglesa', TRUE);

-- ========================================
-- INSERIR TURMAS PADRÃO
-- ========================================
INSERT INTO classes (name, code, level, year, capacity, is_active) VALUES
('Turma A - 1º Ano', 'A-1', '1º Ano', 2024, 30, TRUE),
('Turma B - 1º Ano', 'B-1', '1º Ano', 2024, 30, TRUE),
('Turma A - 2º Ano', 'A-2', '2º Ano', 2024, 30, TRUE),
('Turma B - 2º Ano', 'B-2', '2º Ano', 2024, 30, TRUE),
('Turma A - 3º Ano', 'A-3', '3º Ano', 2024, 25, TRUE);

-- ========================================
-- INSERIR ITEM FINANCEIRO PADRÃO
-- ========================================
INSERT INTO financial_items (description, type, amount, due_date, is_active) VALUES
('Mensalidade', 'tuition', 500.00, '2024-07-10', TRUE),
('Taxa de Seguro', 'fee', 50.00, '2024-07-10', TRUE),
('Atividades Extracurriculares', 'fee', 100.00, '2024-07-10', TRUE);
