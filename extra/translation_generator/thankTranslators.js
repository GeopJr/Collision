const X2JS = require("x2js");
const parser = new X2JS({ includeWhiteChars: true });
const fs = require("fs");

const regex = {
  lang: /\/\/ ?Language\:(.+)\n/gi,
  translators: /\/\/ ?(.+) \<.+\>, [0-9]{4}.?\n/gi,
};

function scan(obj, translators) {
  return JSON.parse(
    JSON.stringify(obj, function (key, value) {
      if (
        typeof value === "object" &&
        value !== null &&
        value["_id"] === "aboutDialog"
      ) {
        value.property.push({
          _name: "translator-credits",
          __text: `${translators.join("\n")}`,
        });
      }
      return value;
    })
  );
}

function getMeta(content, regex) {
  const matches = [...content.matchAll(regex)];
  return matches.map((x) => x.pop());
}

const langs = fs
  .readdirSync("./translations/", { withFileTypes: false })
  .filter(
    (x) => x.toLowerCase().endsWith(".js") && x.toLowerCase() !== "hashbrown.js"
  );

const baseGlade = fs.readFileSync("./src/translations/hashbrown.glade", "utf8");
const document = parser.xml2js(baseGlade);

const translatorsStrings = [];

for (let i = 0; i < langs.length; i++) {
  const langCode = langs[i].replace(/\.[^/.]+$/, "");

  const translation = fs.readFileSync(`./translations/${langCode}.js`, "utf8");

  const translators = getMeta(translation, regex.translators);
  const lang = getMeta(translation, regex.lang).shift()?.trim().toUpperCase();
  for (let k = 0; k < translators.length; k++) {
    translatorsStrings.push(`${translators[k]} (${lang})`);
  }
}
const translatedGlade = scan(document, translatorsStrings);

const glade2XML =
  `<?xml version="1.0" encoding="UTF-8"?>` + parser.js2xml(translatedGlade);
fs.writeFileSync("./src/translations/hashbrown-thanked.glade", glade2XML);

console.log("Finished thanking translators!");
