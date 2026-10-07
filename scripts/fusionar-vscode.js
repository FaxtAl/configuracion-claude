// Fusiona vscode/settings.json con el settings.json de VS Code de esta PC sin pisarlo:
// las claves que ya existen en la PC se respetan; solo se añaden las que faltan.
// VS Code permite comentarios y comas finales (JSONC), así que se limpian antes de leer.
// Uso: node fusionar-vscode.js <settings base> <settings.json de la PC>
const fs = require("fs");
const path = require("path");

const [rutaBase, rutaDestino] = process.argv.slice(2);

function leerJsonc(ruta) {
  if (!fs.existsSync(ruta)) return {};
  const texto = fs
    .readFileSync(ruta, "utf8")
    .replace(/^\uFEFF/, "")
    .replace(/("(?:\\.|[^"\\])*")|\/\/[^\n]*|\/\*[\s\S]*?\*\//g, (m, cadena) => cadena || "")
    .replace(/,(\s*[}\]])/g, "$1");
  return texto.trim() ? JSON.parse(texto) : {};
}

const base = leerJsonc(rutaBase);
const actual = leerJsonc(rutaDestino);
const resultado = { ...base, ...actual };

fs.mkdirSync(path.dirname(rutaDestino), { recursive: true });
fs.writeFileSync(rutaDestino, JSON.stringify(resultado, null, 2) + "\n");
const nuevas = Object.keys(base).filter((clave) => !(clave in actual)).length;
console.log("settings.json de VS Code fusionado: " + nuevas + " ajustes nuevos.");
