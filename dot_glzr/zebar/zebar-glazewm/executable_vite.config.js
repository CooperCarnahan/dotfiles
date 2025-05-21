import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path'; // Import resolve for path manipulation

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'dist',
    target: 'esnext',
    sourcemap: true,
    emptyOutDir: true, // Add this to clean the dist folder before each build

    rollupOptions: {
      input: {
        // Define your primary layout entry point.
        // This assumes your primary layout's React app is referenced in public/index.html
        primary: resolve(__dirname, 'primary.html'),

        // Define your secondary (workspaces-only) layout entry point.
        // This assumes your secondary layout's React app is referenced in public/secondary.html
        secondary: resolve(__dirname, 'secondary.html'),
      },
      // You can optionally configure output naming conventions here if desired
      // For example, to put JS files in a 'js' subfolder:
      /*
      output: {
        entryFileNames: `js/[name]-[hash].js`,
        chunkFileNames: `js/[name]-[hash].js`,
        assetFileNames: `assets/[name]-[hash].[ext]`,
      },
      */
    },
  },
  base: './', // Ensures relative paths work correctly in the built output
});
