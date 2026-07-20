import { motion } from 'framer-motion';
import Layout from '../components/Layout';
import Card from '../components/Card';
import { Users, BookOpen, DollarSign, BarChart3 } from 'lucide-react';

const stats = [
  { label: 'Total de Alunos', value: '2.543', icon: Users, color: 'bg-blue-100' },
  { label: 'Cursos Ativos', value: '12', icon: BookOpen, color: 'bg-purple-100' },
  { label: 'Receita Mensal', value: 'R$ 45.230', icon: DollarSign, color: 'bg-green-100' },
  { label: 'Aprovação', value: '92%', icon: BarChart3, color: 'bg-orange-100' },
];

const DashboardPage = () => {
  return (
    <Layout>
      <div className="max-w-7xl mx-auto px-4 py-12">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-8"
        >
          <h1 className="text-4xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-gray-600 mt-2">Bem-vindo ao Control SILC</p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ staggerChildren: 0.1, delayChildren: 0.2 }}
          className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-12"
        >
          {stats.map((stat, index) => {
            const Icon = stat.icon;
            return (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.1 }}
              >
                <Card hoverable>
                  <div className="flex items-start justify-between">
                    <div>
                      <p className="text-gray-600 text-sm font-medium">{stat.label}</p>
                      <p className="text-3xl font-bold text-gray-900 mt-2">{stat.value}</p>
                    </div>
                    <div className={`${stat.color} p-3 rounded-lg`}>
                      <Icon className="text-gray-700" size={24} />
                    </div>
                  </div>
                </Card>
              </motion.div>
            );
          })}
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
        >
          <Card>
            <h2 className="text-2xl font-bold text-gray-900 mb-4">Próximos Eventos</h2>
            <div className="space-y-4">
              {[
                { title: 'Reunião de Pais', date: '25 de Julho', time: '18:00' },
                { title: 'Prova Final', date: '28 de Julho', time: '08:00' },
                { title: 'Entrega de Notas', date: '30 de Julho', time: '14:00' },
              ].map((event, i) => (
                <motion.div
                  key={i}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.6 + i * 0.1 }}
                  className="flex justify-between items-center pb-4 border-b last:border-b-0"
                >
                  <div>
                    <p className="font-medium text-gray-900">{event.title}</p>
                    <p className="text-sm text-gray-600">{event.date}</p>
                  </div>
                  <p className="text-primary-600 font-medium">{event.time}</p>
                </motion.div>
              ))}
            </div>
          </Card>
        </motion.div>
      </div>
    </Layout>
  );
};

export default DashboardPage;
