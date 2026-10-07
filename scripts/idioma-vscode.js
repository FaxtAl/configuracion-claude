// Pone VS Code en español añadiendo "locale": "es" a ~/.vscode/argv.json
// (si ya tiene un idioma configurado, lo respeta).
// Uso: node idioma-vscode.js
const fs = require("fs");
const os = require("os");
const path = require("path");

const ruta = path.join(os.homedir(), ".vscode", "argv.json");

if (!fs.existsSync(ruta)) {
  fs.mkdirSync(path.dirname(ruta), { recursive: true });
  fs.writeFileSync(ruta, '{\n\t"locale": "es"\n}\n');
  console.log("argv.json creado con el idioma español.");
} else {
  const texto = fs.readFileSync(ruta, "utf8");
  if (/"locale"\s*:/.test(texto)) {
    console.log("VS Code ya tenía un idioma configurado: se respeta.");
  } else {
    fs.writeFileSync(ruta, texto.replace("{", '{\n\t"locale": "es",'));
    console.log("Idioma de VS Code: español.");
  }
}
