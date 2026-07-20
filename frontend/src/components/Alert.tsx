import { motion } from 'framer-motion';
import { AlertCircle, CheckCircle, Info, AlertTriangle, X } from 'lucide-react';
import { useState } from 'react';

interface AlertProps {
  type?: 'success' | 'error' | 'warning' | 'info';
  title?: string;
  message: string;
  closeable?: boolean;
  onClose?: () => void;
}

const Alert = ({ type = 'info', title, message, closeable = true, onClose }: AlertProps) => {
  const [isVisible, setIsVisible] = useState(true);

  const handleClose = () => {
    setIsVisible(false);
    onClose?.();
  };

  if (!isVisible) return null;

  const typeConfig = {
    success: {
      icon: CheckCircle,
      bg: 'bg-success-50',
      border: 'border-success-200',
      text: 'text-success-800',
      iconColor: 'text-success-600',
    },
    error: {
      icon: AlertCircle,
      bg: 'bg-danger-50',
      border: 'border-danger-200',
      text: 'text-danger-800',
      iconColor: 'text-danger-600',
    },
    warning: {
      icon: AlertTriangle,
      bg: 'bg-warning-50',
      border: 'border-warning-200',
      text: 'text-warning-800',
      iconColor: 'text-warning-600',
    },
    info: {
      icon: Info,
      bg: 'bg-primary-50',
      border: 'border-primary-200',
      text: 'text-primary-800',
      iconColor: 'text-primary-600',
    },
  };

  const config = typeConfig[type];
  const Icon = config.icon;

  return (
    <motion.div
      initial={{ opacity: 0, x: -20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className={`${config.bg} ${config.border} border rounded-lg p-4 flex gap-3`}
    >
      <Icon className={`${config.iconColor} flex-shrink-0 mt-0.5`} size={20} />
      <div className="flex-1">
        {title && <h3 className={`${config.text} font-semibold mb-1`}>{title}</h3>}
        <p className={`${config.text} text-sm`}>{message}</p>
      </div>
      {closeable && (
        <button onClick={handleClose} className="text-gray-400 hover:text-gray-600">
          <X size={18} />
        </button>
      )}
    </motion.div>
  );
};

export default Alert;
