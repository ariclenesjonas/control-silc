<?php
/**
 * Control SILC - Sistema Integrado de Gestão Escolar
 * Helper Functions
 * 
 * @author Arícle Nésjo
 * @version 1.0.0
 */

/**
 * Exibe valor e para execução (Debug)
 */
function dd($value)
{
    echo '<pre>';
    var_dump($value);
    echo '</pre>';
    exit;
}

/**
 * Exibe valor sem parar execução (Debug)
 */
function dump($value)
{
    echo '<pre>';
    var_dump($value);
    echo '</pre>';
}

/**
 * Obtém valor de array com valor padrão
 */
function get_array_value($array, $key, $default = null)
{
    return isset($array[$key]) ? $array[$key] : $default;
}

/**
 * Formata valor monetário para exibição
 */
function format_money($value)
{
    return 'R$ ' . number_format($value, 2, ',', '.');
}

/**
 * Formata data para exibição
 */
function format_date($date, $format = DATE_FORMAT)
{
    if (empty($date)) {
        return '';
    }
    
    try {
        $datetime = new DateTime($date);
        return $datetime->format($format);
    } catch (Exception $e) {
        return $date;
    }
}

/**
 * Formata data e hora para exibição
 */
function format_datetime($datetime, $format = DATETIME_FORMAT)
{
    if (empty($datetime)) {
        return '';
    }
    
    try {
        $dt = new DateTime($datetime);
        return $dt->format($format);
    } catch (Exception $e) {
        return $datetime;
    }
}

/**
 * Converte data do formato brasileiro para SQL
 */
function date_to_sql($date)
{
    if (empty($date)) {
        return null;
    }
    
    try {
        $datetime = DateTime::createFromFormat(DATE_FORMAT, $date);
        if ($datetime === false) {
            return null;
        }
        return $datetime->format('Y-m-d');
    } catch (Exception $e) {
        return null;
    }
}

/**
 * Trunca texto com reticências
 */
function truncate_text($text, $length = 50)
{
    if (strlen($text) > $length) {
        return substr($text, 0, $length) . '...';
    }
    return $text;
}

/**
 * Gera slug a partir de texto
 */
function generate_slug($text)
{
    $slug = strtolower(trim($text));
    $slug = preg_replace('/[^a-z0-9]+/', '-', $slug);
    $slug = trim($slug, '-');
    return $slug;
}

/**
 * Gera token aleatório
 */
function generate_token($length = CSRF_TOKEN_LENGTH)
{
    return bin2hex(random_bytes($length / 2));
}

/**
 * Sanitiza entrada de usuário
 */
function sanitize_input($input)
{
    if (is_array($input)) {
        return array_map('sanitize_input', $input);
    }
    
    return htmlspecialchars(trim($input), ENT_QUOTES, 'UTF-8');
}

/**
 * Obtém IP do cliente
 */
function get_client_ip()
{
    if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    } elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ip = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR'])[0];
    } else {
        $ip = $_SERVER['REMOTE_ADDR'];
    }
    
    return filter_var($ip, FILTER_VALIDATE_IP) ? $ip : '0.0.0.0';
}

/**
 * Obtém nome do perfil
 */
function get_role_name($role_id)
{
    return ROLES[$role_id] ?? 'Desconhecido';
}

/**
 * Obtém nome do status
 */
function get_status_badge($status)
{
    $badges = [
        'active' => '<span class="badge bg-success">Ativo</span>',
        'inactive' => '<span class="badge bg-secondary">Inativo</span>',
        'pending' => '<span class="badge bg-warning">Pendente</span>',
        'suspended' => '<span class="badge bg-danger">Suspenso</span>',
    ];
    
    return $badges[$status] ?? '<span class="badge bg-secondary">Desconhecido</span>';
}

/**
 * Redirecionamento com mensagem
 */
function redirect($url, $message = null, $type = 'info')
{
    if ($message) {
        $_SESSION['message'] = [
            'text' => $message,
            'type' => $type,
        ];
    }
    
    header('Location: ' . $url);
    exit;
}

/**
 * Obtém mensagem de sessão
 */
function get_message()
{
    if (isset($_SESSION['message'])) {
        $message = $_SESSION['message'];
        unset($_SESSION['message']);
        return $message;
    }
    
    return null;
}

/**
 * Converte array para JSON
 */
function to_json($data)
{
    return json_encode($data, JSON_UNESCAPED_UNICODE);
}

/**
 * Converte JSON para array
 */
function from_json($json)
{
    return json_decode($json, true);
}

/**
 * Verifica se é requisição AJAX
 */
function is_ajax()
{
    return !empty($_SERVER['HTTP_X_REQUESTED_WITH']) && 
           strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest';
}

/**
 * Verifica se é requisição POST
 */
function is_post()
{
    return $_SERVER['REQUEST_METHOD'] === 'POST';
}

/**
 * Verifica se é requisição GET
 */
function is_get()
{
    return $_SERVER['REQUEST_METHOD'] === 'GET';
}

/**
 * Obtém valor de $_GET ou $_POST com segurança
 */
function request_input($key, $default = null, $filter = null)
{
    $value = $_POST[$key] ?? $_GET[$key] ?? $default;
    
    if ($value && $filter) {
        $value = filter_var($value, $filter);
    }
    
    return $value;
}

/**
 * Log de erro
 */
function log_error($message, $context = [])
{
    Logger::error($message, $context);
}

/**
 * Log de info
 */
function log_info($message, $context = [])
{
    Logger::info($message, $context);
}

/**
 * Log de warning
 */
function log_warning($message, $context = [])
{
    Logger::warning($message, $context);
}

/**
 * Renderiza view
 */
function view($path, $data = [])
{
    extract($data);
    $file = VIEWS_PATH . '/' . str_replace('.', '/', $path) . '.php';
    
    if (!file_exists($file)) {
        throw new Exception("View not found: {$path}");
    }
    
    include $file;
}

/**
 * Renderiza JSON
 */
function json_response($data, $statusCode = 200)
{
    http_response_code($statusCode);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}
?>
