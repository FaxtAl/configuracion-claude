// Fusiona claude/settings-base.json con el settings.json de esta PC sin pisarlo:
// - las claves que ya existen en la PC se respetan (tema, hooks, etc.);
// - los permisos "allow" de la base se suman a los que ya había.
// Uso: node fusionar-settings.js <settings-base.json> <settings.json de la PC>
const fs = require("fs");

const [rutaBase, rutaDestino] = process.argv.slice(2);
const base = JSON.parse(fs.readFileSync(rutaBase, "utf8"));
const actual = fs.existsSync(rutaDestino) ? JSON.parse(fs.readFileSync(rutaDestino, "utf8")) : {};

const resultado = { ...base, ...actual };

const permisosBase = (base.permissions && base.permissions.allow) || [];
const permisosActuales = (actual.permissions && actual.permissions.allow) || [];
resultado.permissions = {
  ...(base.permissions || {}),
  ...(actual.permissions || {}),
  allow: [...new Set([...permisosActuales, ...permisosBase])],
};

fs.writeFileSync(rutaDestino, JSON.stringify(resultado, null, 2) + "\n");
console.log("settings.json fusionado: " + resultado.permissions.allow.length + " permisos.");
