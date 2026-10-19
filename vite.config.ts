import { defineConfig } from "vite";
import { tanstackStart } from "@tanstack/react-start/plugin/vite";
import viteReact from "@vitejs/plugin-react";
import tailwindcss from "@tailwindcss/vite";
import tsconfigPaths from "vite-tsconfig-paths";

const base = process.env.BASE_URL || (process.env.GITHUB_ACTIONS ? "/csp/" : "/");

export default defineConfig({
  base,
  plugins: [
    tanstackStart({
      server: {
        entry: "./src/server.ts",
      },
      prerender: {
        enabled: true,
      },
    }),
    viteReact(),
    tailwindcss(),
    tsconfigPaths(),
  ],
});
