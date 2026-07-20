import { motion } from 'framer-motion';
import Layout from '../components/Layout';
import Card from '../components/Card';
import Button from '../components/Button';
import { Plus, Edit2, Trash2 } from 'lucide-react';
import { useState, useEffect } from 'react';
import Skeleton from '../components/Skeleton';
import api from '../services/api';

const StudentsPage = () => {
  const [students, setStudents] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    const fetchStudents = async () => {
      try {
        const response = await api.get('/students');
        setStudents(response.data);
      } catch (error) {
        console.error('Erro ao buscar alunos:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchStudents();
  }, []);

  const filteredStudents = students.filter(
    (student) =>
      student.registration_number.toLowerCase().includes(searchTerm.toLowerCase()) ||
      student.guardian_name?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <Layout>
      <div className="max-w-7xl mx-auto px-4 py-12">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="flex justify-between items-center mb-8"
        >
          <div>
            <h1 className="text-4xl font-bold text-gray-900">Alunos</h1>
            <p className="text-gray-600 mt-2">Gerenciar cadastro de alunos</p>
          </div>
          <Button icon={<Plus size={20} />}>Novo Aluno</Button>
        </motion.div>

        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="mb-6">
          <input
            type="text"
            placeholder="Buscar aluno..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
          />
        </motion.div>

        {loading ? (
          <Card>
            <Skeleton count={5} height="h-16" />
          </Card>
        ) : (
          <Card>
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="border-b">
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Matrícula</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Responsável</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">E-mail</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Telefone</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Status</th>
                    <th className="text-left py-3 px-4 font-semibold text-gray-900">Ações</th>
                  </tr>
                </thead>
                <tbody>
                  {filteredStudents.length > 0 ? (
                    filteredStudents.map((student, index) => (
                      <motion.tr
                        key={student.id}
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        transition={{ delay: index * 0.05 }}
                        className="border-b hover:bg-gray-50 transition"
                      >
                        <td className="py-3 px-4 text-gray-900 font-medium">{student.registration_number}</td>
                        <td className="py-3 px-4 text-gray-600">{student.guardian_name}</td>
                        <td className="py-3 px-4 text-gray-600">{student.guardian_email}</td>
                        <td className="py-3 px-4 text-gray-600">{student.guardian_phone}</td>
                        <td className="py-3 px-4">
                          <span
                            className={`px-3 py-1 rounded-full text-sm font-medium ${
                              student.is_active
                                ? 'bg-green-100 text-green-800'
                                : 'bg-gray-100 text-gray-800'
                            }`}
                          >
                            {student.is_active ? 'Ativo' : 'Inativo'}
                          </span>
                        </td>
                        <td className="py-3 px-4 flex gap-2">
                          <button className="p-2 text-gray-600 hover:bg-gray-100 rounded transition">
                            <Edit2 size={16} />
                          </button>
                          <button className="p-2 text-danger-600 hover:bg-danger-100 rounded transition">
                            <Trash2 size={16} />
                          </button>
                        </td>
                      </motion.tr>
                    ))
                  ) : (
                    <tr>
                      <td colSpan={6} className="py-8 text-center text-gray-600">
                        Nenhum aluno encontrado
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </Card>
        )}
      </div>
    </Layout>
  );
};

export default StudentsPage;
