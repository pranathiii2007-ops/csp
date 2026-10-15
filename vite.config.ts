import { defineConfig } from "@tanstack/react-start/config";
import tailwindcss from "@tailwindcss/vite";
import tsconfigPaths from "vite-tsconfig-paths";

export default defineConfig({
  server: {
    entry: "./src/server.ts",
  },
  vite: {
    plugins: [
      tailwindcss(),
      tsconfigPaths(),
    ],
  },
});
