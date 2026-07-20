<?php
/**
 * Control SILC - Sistema Integrado de Gestão Escolar
 * Dashboard Controller
 * 
 * @author Arícle Nésjo
 * @version 1.0.0
 */

require_once CONTROLLERS_PATH . '/BaseController.php';
require_once MODELS_PATH . '/User.php';

class DashboardController extends BaseController
{
    private User $userModel;

    public function __construct()
    {
        parent::__construct();
        $this->userModel = new User();
    }

    /**
     * Exibe dashboard principal
     */
    public function index()
    {
        $this->auth_required();

        $user = Auth::user();
        
        // Dados para dashboard (serão expandidos com modelos específicos)
        $stats = [
            'total_users' => $this->userModel->count(),
            'total_active' => $this->userModel->count("status = '" . STATUS_ACTIVE . "'"),
            'total_inactive' => $this->userModel->count("status = '" . STATUS_INACTIVE . "'"),
        ];

        $this->set('title', 'Dashboard - Control SILC');
        $this->set('user', $user);
        $this->set('stats', $stats);

        $this->render('dashboard.index');
    }

    /**
     * Exibe perfil do usuário
     */
    public function profile()
    {
        $this->auth_required();

        $user_id = Auth::id();
        $user = $this->userModel->find($user_id);

        if (!$user) {
            redirect(APP_URL . '/dashboard', 'Usuário não encontrado.', 'danger');
        }

        $this->set('title', 'Meu Perfil - Control SILC');
        $this->set('user_data', $user);
        $this->render('dashboard.profile');
    }

    /**
     * Atualiza perfil do usuário
     */
    public function update_profile()
    {
        $this->auth_required();
        $this->validate_csrf();

        if (!is_post()) {
            redirect(APP_URL . '/profile');
        }

        $user_id = Auth::id();
        
        $data = [
            'name' => $_POST['name'] ?? '',
            'phone' => $_POST['phone'] ?? '',
            'address' => $_POST['address'] ?? '',
            'city' => $_POST['city'] ?? '',
            'state' => $_POST['state'] ?? '',
            'zipcode' => $_POST['zipcode'] ?? '',
        ];

        $validator = new Validator($data);
        $validator->required('name', 'Nome é obrigatório')
                  ->min('name', 3, 'Nome deve ter no mínimo 3 caracteres');

        if ($validator->fails()) {
            redirect(APP_URL . '/profile', 'Por favor, verifique os erros.', 'danger');
        }

        try {
            $this->userModel->update($user_id, $data);
            $this->log_action('UPDATE_PROFILE', 'users', $user_id);
            redirect(APP_URL . '/profile', 'Perfil atualizado com sucesso!', 'success');
        } catch (Exception $e) {
            Logger::error('Profile update error: ' . $e->getMessage());
            redirect(APP_URL . '/profile', 'Erro ao atualizar perfil.', 'danger');
        }
    }

    /**
     * Altera senha do usuário
     */
    public function change_password()
    {
        $this->auth_required();
        $this->validate_csrf();

        if (!is_post()) {
            redirect(APP_URL . '/profile');
        }

        $user_id = Auth::id();
        $current_password = $_POST['current_password'] ?? '';
        $new_password = $_POST['new_password'] ?? '';
        $new_password_confirmation = $_POST['new_password_confirmation'] ?? '';

        $user = $this->userModel->find($user_id);

        // Valida senha atual
        if (!Auth::validate_password($current_password, $user['password'])) {
            redirect(APP_URL . '/profile', 'Senha atual está incorreta.', 'danger');
        }

        $validator = new Validator([
            'new_password' => $new_password,
            'new_password_confirmation' => $new_password_confirmation,
        ]);

        $validator->required('new_password', 'Nova senha é obrigatória')
                  ->min('new_password', 8, 'Nova senha deve ter no mínimo 8 caracteres')
                  ->confirmed('new_password', 'As senhas não correspondem');

        if ($validator->fails()) {
            redirect(APP_URL . '/profile', 'Por favor, verifique os erros.', 'danger');
        }

        try {
            $this->userModel->update($user_id, [
                'password' => Auth::hash_password($new_password)
            ]);

            $this->log_action('CHANGE_PASSWORD', 'users', $user_id);
            redirect(APP_URL . '/profile', 'Senha alterada com sucesso!', 'success');
        } catch (Exception $e) {
            Logger::error('Password change error: ' . $e->getMessage());
            redirect(APP_URL . '/profile', 'Erro ao alterar senha.', 'danger');
        }
    }
}
?>
