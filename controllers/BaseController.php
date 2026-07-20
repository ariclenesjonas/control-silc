<?php
/**
 * Control SILC - Sistema Integrado de Gestão Escolar
 * Base Controller Class
 * 
 * @author Arícle Nésjo
 * @version 1.0.0
 */

abstract class BaseController
{
    protected array $data = [];

    /**
     * Verifica se usuário está autenticado
     */
    protected function auth_required()
    {
        if (!Auth::check()) {
            redirect(APP_URL . '/login', 'Você precisa fazer login para acessar esta página.', 'warning');
        }
    }

    /**
     * Verifica se usuário tem role específico
     */
    protected function role_required($role_id)
    {
        if (!Auth::is_role($role_id)) {
            redirect(APP_URL . '/403', 'Você não tem permissão para acessar este recurso.', 'danger');
        }
    }

    /**
     * Verifica se usuário tem alguma das roles
     */
    protected function roles_required($roles)
    {
        if (!Auth::in_roles($roles)) {
            redirect(APP_URL . '/403', 'Você não tem permissão para acessar este recurso.', 'danger');
        }
    }

    /**
     * Verifica se usuário tem permissão
     */
    protected function permission_required($permission)
    {
        if (!Auth::can($permission)) {
            redirect(APP_URL . '/403', 'Você não tem permissão para realizar esta ação.', 'danger');
        }
    }

    /**
     * Valida CSRF token
     */
    protected function validate_csrf()
    {
        if (!Csrf::validate()) {
            json_response(['error' => 'CSRF token inválido'], 403);
        }
    }

    /**
     * Renderiza view
     */
    protected function render($view, $data = [])
    {
        $this->data = array_merge($this->data, $data);
        
        extract($this->data);
        
        $file = VIEWS_PATH . '/' . str_replace('.', '/', $view) . '.php';
        
        if (!file_exists($file)) {
            throw new Exception("View not found: {$view}");
        }
        
        include $file;
    }

    /**
     * Retorna JSON
     */
    protected function json($data, $statusCode = 200)
    {
        http_response_code($statusCode);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($data, JSON_UNESCAPED_UNICODE);
        exit;
    }

    /**
     * Retorna erro JSON
     */
    protected function error_json($message, $statusCode = 400)
    {
        $this->json([
            'success' => false,
            'error' => $message,
        ], $statusCode);
    }

    /**
     * Retorna sucesso JSON
     */
    protected function success_json($message, $data = [])
    {
        $this->json(array_merge([
            'success' => true,
            'message' => $message,
        ], $data));
    }

    /**
     * Define dado para view
     */
    protected function set($key, $value)
    {
        $this->data[$key] = $value;
    }

    /**
     * Obtém dado
     */
    protected function get($key, $default = null)
    {
        return $this->data[$key] ?? $default;
    }

    /**
     * Valida entrada de formulário
     */
    protected function validate_form($data, $rules)
    {
        $validator = new Validator($data);
        
        foreach ($rules as $field => $fieldRules) {
            foreach ($fieldRules as $rule) {
                $parts = explode(':', $rule);
                $ruleName = $parts[0];
                $ruleParam = $parts[1] ?? null;

                switch ($ruleName) {
                    case 'required':
                        $validator->required($field);
                        break;
                    case 'email':
                        $validator->email($field);
                        break;
                    case 'min':
                        $validator->min($field, (int)$ruleParam);
                        break;
                    case 'max':
                        $validator->max($field, (int)$ruleParam);
                        break;
                    case 'phone':
                        $validator->phone($field);
                        break;
                    case 'cpf':
                        $validator->cpf($field);
                        break;
                    case 'numeric':
                        $validator->numeric($field);
                        break;
                    case 'date':
                        $validator->date($field);
                        break;
                }
            }
        }

        return $validator;
    }

    /**
     * Log de ação
     */
    protected function log_action($action, $resource, $resource_id, $details = [])
    {
        Logger::audit($action, $resource, $resource_id, $details);
    }
}
?>
