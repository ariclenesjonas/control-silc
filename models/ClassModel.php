<?php
/**
 * Control SILC - Sistema Integrado de Gestão Escolar
 * Class (Turma) Model
 * 
 * @author Arícle Nésjo
 * @version 1.0.0
 */

require_once __DIR__ . '/BaseModel.php';

class ClassModel extends BaseModel
{
    protected string $table = 'classes';
    protected array $fillable = [
        'academic_year_id',
        'course_id',
        'name',
        'code',
        'teacher_id',
        'max_students',
        'status',
    ];

    /**
     * Busca classe por código
     */
    public function find_by_code($code)
    {
        return $this->first_where('code', $code);
    }

    /**
     * Obtém dados completos da classe
     */
    public function get_with_details($class_id)
    {
        $query = "SELECT c.*, 
                         ay.name as academic_year_name, 
                         cr.name as course_name,
                         t.id as teacher_id_data,
                         u.name as teacher_name,
                         COUNT(e.id) as student_count
                  FROM {$this->table} c
                  LEFT JOIN academic_years ay ON c.academic_year_id = ay.id
                  LEFT JOIN courses cr ON c.course_id = cr.id
                  LEFT JOIN teachers t ON c.teacher_id = t.id
                  LEFT JOIN users u ON t.user_id = u.id
                  LEFT JOIN enrollments e ON c.id = e.class_id
                  WHERE c.id = ? AND c.deleted_at IS NULL
                  GROUP BY c.id";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$class_id]);
        return $stmt->fetch();
    }

    /**
     * Obtém alunos da classe
     */
    public function get_students($class_id)
    {
        $query = "SELECT e.*, s.id as student_id, u.name, u.email
                  FROM enrollments e
                  INNER JOIN students s ON e.student_id = s.id
                  INNER JOIN users u ON s.user_id = u.id
                  WHERE e.class_id = ? AND e.status = ? AND e.deleted_at IS NULL
                  ORDER BY u.name ASC";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$class_id, STATUS_ACTIVE]);
        return $stmt->fetchAll();
    }

    /**
     * Obtém disciplinas da classe
     */
    public function get_disciplines($class_id)
    {
        $query = "SELECT cd.*, d.name, d.code, t.id as teacher_id_data, u.name as teacher_name
                  FROM class_disciplines cd
                  INNER JOIN disciplines d ON cd.discipline_id = d.id
                  INNER JOIN teachers t ON cd.teacher_id = t.id
                  INNER JOIN users u ON t.user_id = u.id
                  WHERE cd.class_id = ? 
                  ORDER BY d.name ASC";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$class_id]);
        return $stmt->fetchAll();
    }

    /**
     * Obtém horários da classe
     */
    public function get_schedule($class_id)
    {
        $query = "SELECT s.*, d.name as discipline_name, r.name as room_name, t.id as teacher_id_data, u.name as teacher_name
                  FROM schedules s
                  LEFT JOIN disciplines d ON s.discipline_id = d.id
                  LEFT JOIN rooms r ON s.room_id = r.id
                  LEFT JOIN class_disciplines cd ON d.id = cd.discipline_id AND cd.class_id = s.class_id
                  LEFT JOIN teachers t ON cd.teacher_id = t.id
                  LEFT JOIN users u ON t.user_id = u.id
                  WHERE s.class_id = ? AND s.deleted_at IS NULL
                  ORDER BY s.day_of_week ASC, s.start_time ASC";
        
        $stmt = $this->db->prepare($query);
        $stmt->execute([$class_id]);
        return $stmt->fetchAll();
    }

    /**
     * Verifica se classe está cheia
     */
    public function is_full($class_id)
    {
        $class = $this->find($class_id);
        $students = count($this->get_students($class_id));
        
        return $students >= $class['max_students'];
    }

    /**
     * Obtém vagas disponíveis
     */
    public function get_available_slots($class_id)
    {
        $class = $this->find($class_id);
        $students = count($this->get_students($class_id));
        
        return max(0, $class['max_students'] - $students);
    }

    /**
     * Cria nova classe
     */
    public function create_class($data)
    {
        if (!isset($data['code'])) {
            $data['code'] = $this->generate_class_code($data['academic_year_id'], $data['course_id']);
        }

        if (!isset($data['status'])) {
            $data['status'] = STATUS_ACTIVE;
        }

        return $this->create($data);
    }

    /**
     * Gera código único para classe
     */
    private function generate_class_code($academic_year_id, $course_id)
    {
        $ay = $this->db->prepare("SELECT year FROM academic_years WHERE id = ?")->execute([$academic_year_id]);
        $course = $this->db->prepare("SELECT code FROM courses WHERE id = ?")->execute([$course_id]);
        
        $count = $this->count("academic_year_id = {$academic_year_id} AND course_id = {$course_id}");
        return "{$course['code']}{$academic_year_id}." . str_pad($count + 1, 2, '0', STR_PAD_LEFT);
    }

    /**
     * Obtém classes por ano letivo
     */
    public function get_by_academic_year($academic_year_id)
    {
        return $this->where('academic_year_id', $academic_year_id);
    }

    /**
     * Obtém classes de um professor
     */
    public function get_by_teacher($teacher_id)
    {
        return $this->where('teacher_id', $teacher_id);
    }
}
?>
