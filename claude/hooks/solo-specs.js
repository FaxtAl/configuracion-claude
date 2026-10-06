// Hook PreToolUse del agente planner: solo permite escribir dentro de specs/.
// Equivale al permiso del curso: edit "*" deny + edit "specs/**" allow.
const path = require("path");

let input = "";
process.stdin.on("data", (chunk) => (input += chunk));
process.stdin.on("end", () => {
  const data = JSON.parse(input || "{}");
  const toolInput = data.tool_input || {};
  const target = toolInput.file_path || toolInput.notebook_path;
  if (!target) process.exit(0);

  const projectDir = process.env.CLAUDE_PROJECT_DIR || data.cwd || process.cwd();
  const relative = path.relative(projectDir, path.resolve(projectDir, target)).split(path.sep).join("/");

  if (relative.startsWith("specs/")) process.exit(0);

  console.error(`Bloqueado: el planner solo puede escribir dentro de specs/ (intentó: ${relative}).`);
  process.exit(2);
});
