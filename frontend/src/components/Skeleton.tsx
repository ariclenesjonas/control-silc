import { motion } from 'framer-motion';

interface SkeletonProps {
  width?: string;
  height?: string;
  className?: string;
  count?: number;
}

const Skeleton = ({ width = 'w-full', height = 'h-4', className = '', count = 1 }: SkeletonProps) => {
  return (
    <div className={className}>
      {Array.from({ length: count }).map((_, i) => (
        <motion.div
          key={i}
          className={`${width} ${height} bg-gray-200 rounded mb-2 last:mb-0`}
          animate={{ opacity: [0.5, 1, 0.5] }}
          transition={{ duration: 1.5, repeat: Infinity }}
        />
      ))}
    </div>
  );
};

export default Skeleton;
