/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Universal Framework Phase Colors
        phase: {
          define: '#3B82F6',      // blue-500
          decompose: '#8B5CF6',   // violet-500
          prioritize: '#F59E0B',  // amber-500
          sequence: '#10B981',    // emerald-500
          execute: '#EF4444',     // red-500
          review: '#6366F1',      // indigo-500
        },
        // Execution Phase Colors
        execution: {
          foundation: '#3B82F6',  // blue-500
          build: '#10B981',       // emerald-500
          enhance: '#F59E0B',     // amber-500
          finalize: '#8B5CF6',    // violet-500
        },
        // Task Status Colors
        status: {
          backlog: '#6B7280',     // gray-500
          in_progress: '#3B82F6', // blue-500
          review: '#F59E0B',      // amber-500
          blocked: '#EF4444',     // red-500
          done: '#10B981',        // emerald-500
          skipped: '#9CA3AF',     // gray-400
        },
        // Priority Colors
        priority: {
          critical: '#EF4444',    // red-500
          high: '#F97316',        // orange-500
          medium: '#F59E0B',      // amber-500
          low: '#6B7280',         // gray-500
        },
      },
    },
  },
  plugins: [],
}
