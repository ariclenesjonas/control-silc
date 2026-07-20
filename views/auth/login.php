<?php include VIEWS_PATH . '/layouts/auth.php'; ?>

<div class="login-card">
    <div class="login-header">
        <h1><i class="fas fa-sign-in-alt"></i> Login</h1>
        <p>Control SILC - Sistema Integrado de Gestão Escolar</p>
    </div>

    <div class="login-body">
        <?php if (Session::has_flash('errors')): ?>
            <div class="alert alert-danger">
                <strong>Erros encontrados:</strong>
                <ul class="mb-0">
                    <?php foreach (Session::get_flash('errors') as $error): ?>
                        <li><?php echo $error; ?></li>
                    <?php endforeach; ?>
                </ul>
            </div>
        <?php endif; ?>

        <form method="POST" action="<?php echo APP_URL; ?>/login" class="needs-validation">
            <?php echo Csrf::field(); ?>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" class="form-control" id="email" name="email" 
                       value="<?php echo sanitize_input($_POST['email'] ?? ''); ?>" 
                       placeholder="seu@email.com" required>
            </div>

            <div class="form-group">
                <label for="password">Senha</label>
                <input type="password" class="form-control" id="password" name="password" 
                       placeholder="Sua senha" required>
            </div>

            <div class="remember-me">
                <input type="checkbox" class="form-check-input" id="remember" name="remember">
                <label class="form-check-label" for="remember">Lembrar-me</label>
            </div>

            <button type="submit" class="btn-login">
                <i class="fas fa-sign-in-alt"></i> Entrar no Sistema
            </button>
        </form>
    </div>

    <div class="login-footer">
        <p>Esqueceu sua senha? <a href="<?php echo APP_URL; ?>/forgot-password">Clique aqui</a></p>
    </div>
</div>

<?php include VIEWS_PATH . '/layouts/auth_footer.php'; ?>
