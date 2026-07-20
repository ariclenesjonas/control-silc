<?php
/**
 * Control SILC - Sistema Integrado de Gestão Escolar
 * Session Manager
 * 
 * @author Arícle Nésjo
 * @version 1.0.0
 */

class Session
{
    /**
     * Inicia sessão
     */
    public static function start()
    {
        if (session_status() !== PHP_SESSION_ACTIVE) {
            session_start();
            
            // Configura cookies de sessão
            $lifetime = (int)($_ENV['SESSION_LIFETIME'] ?? SESSION_LIFETIME);
            ini_set('session.gc_maxlifetime', $lifetime * 60);
        }
    }

    /**
     * Define valor de sessão
     */
    public static function set($key, $value)
    {
        $_SESSION[$key] = $value;
    }

    /**
     * Obtém valor de sessão
     */
    public static function get($key, $default = null)
    {
        return $_SESSION[$key] ?? $default;
    }

    /**
     * Verifica se chave existe em sessão
     */
    public static function has($key)
    {
        return isset($_SESSION[$key]);
    }

    /**
     * Remove valor de sessão
     */
    public static function remove($key)
    {
        unset($_SESSION[$key]);
    }

    /**
     * Destroi sessão
     */
    public static function destroy()
    {
        $_SESSION = [];
        
        if (ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            setcookie(
                session_name(),
                '',
                time() - 42000,
                $params['path'],
                $params['domain'],
                $params['secure'],
                $params['httponly']
            );
        }
        
        session_destroy();
    }

    /**
     * Regenera ID de sessão (segurança)
     */
    public static function regenerate()
    {
        session_regenerate_id(true);
    }

    /**
     * Obtém ID de sessão
     */
    public static function id()
    {
        return session_id();
    }

    /**
     * Verifica timeout de sessão
     */
    public static function check_timeout()
    {
        $timeout = (int)($_ENV['SESSION_LIFETIME'] ?? SESSION_LIFETIME) * 60;
        
        if (isset($_SESSION['last_activity'])) {
            if (time() - $_SESSION['last_activity'] > $timeout) {
                self::destroy();
                return false;
            }
        }
        
        $_SESSION['last_activity'] = time();
        return true;
    }

    /**
     * Registra mensagem flash
     */
    public static function flash($key, $message)
    {
        $_SESSION['flash'][$key] = $message;
    }

    /**
     * Obtém e remove mensagem flash
     */
    public static function get_flash($key, $default = null)
    {
        $message = $_SESSION['flash'][$key] ?? $default;
        unset($_SESSION['flash'][$key]);
        return $message;
    }

    /**
     * Verifica se há mensagem flash
     */
    public static function has_flash($key)
    {
        return isset($_SESSION['flash'][$key]);
    }

    /**
     * Retorna todos os dados de sessão
     */
    public static function all()
    {
        return $_SESSION;
    }
}
?>
