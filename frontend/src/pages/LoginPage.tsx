import { motion } from 'framer-motion';
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useForm } from 'react-hook-form';
import Layout from '../components/Layout';
import Input from '../components/Input';
const Button = require('../components/Button').default;
import Alert from '../components/Alert';
import { authService } from '../services/authService';
import { useAuthStore } from '../store/authStore';
import { Mail, Lock } from 'lucide-react';

interface LoginForm {
  email: string;
  password: string;
}

const LoginPage = () => {
  const { register, handleSubmit, formState: { errors } } = useForm<LoginForm>();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();
  const setTokens = useAuthStore((state) => state.setTokens);
  const setUser = useAuthStore((state) => state.setUser);

  const onSubmit = async (data: LoginForm) => {
    setLoading(true);
    setError(null);

    try {
      const response = await authService.login(data.email, data.password);
      setTokens(response.access_token, response.refresh_token);
      setUser({ email: data.email });
      navigate('/dashboard');
    } catch (err: any) {
      setError(err.response?.data?.detail || 'Erro ao fazer login');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Layout>
      <div className="min-h-[calc(100vh-64px)] flex items-center justify-center py-12 px-4">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.5 }}
          className="w-full max-w-md"
        >
          <div className="bg-white rounded-lg shadow-lg p-8">
            <div className="text-center mb-8">
              <div className="inline-block w-16 h-16 bg-gradient-to-br from-primary-600 to-secondary-600 rounded-lg flex items-center justify-center mb-4">
                <span className="text-2xl font-bold text-white">CS</span>
              </div>
              <h1 className="text-3xl font-bold text-gray-900">Control SILC</h1>
              <p className="text-gray-600 mt-2">Sistema Integrado de Gestão Escolar</p>
            </div>

            {error && (
              <Alert
                type="error"
                title="Erro"
                message={error}
                onClose={() => setError(null)}
              />
            )}

            <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
              <Input
                label="Email"
                type="email"
                placeholder="seu@email.com"
                icon={<Mail size={18} />}
                {...register('email', {
                  required: 'Email é obrigatório',
                  pattern: {
                    value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i,
                    message: 'Email inválido',
                  },
                })}
                error={errors.email?.message}
              />

              <Input
                label="Senha"
                type="password"
                placeholder="Sua senha"
                icon={<Lock size={18} />}
                {...register('password', {
                  required: 'Senha é obrigatória',
                  minLength: {
                    value: 8,
                    message: 'Senha deve ter no mínimo 8 caracteres',
                  },
                })}
                error={errors.password?.message}
              />

              <Button
                type="submit"
                fullWidth
                loading={loading}
                size="lg"
              >
                Entrar
              </Button>
            </form>

            <p className="text-center text-gray-600 mt-6">
              Credenciais padrão:
              <br />
              <code className="bg-gray-100 px-2 py-1 rounded text-sm">admin@control-silc.com</code>
              <br />
              <code className="bg-gray-100 px-2 py-1 rounded text-sm">Control@123</code>
            </p>
          </div>
        </motion.div>
      </div>
    </Layout>
  );
};

export default LoginPage;
