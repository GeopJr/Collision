const X2JS = require("x2js");
const parser = new X2JS();
const fs = require("fs");

function translate(text, langObj) {
  let response = text;
  if (
    langObj.hasOwnProperty(response) &&
    langObj[response].hasOwnProperty("translation") &&
    langObj[response].translation.length > 0
  ) {
    response = langObj[response].translation;
  }
  return response;
}

function scan(obj, langObj) {
  return JSON.parse(
    JSON.stringify(obj, function (key, value) {
      if (typeof value === "object" && value !== null && value["__text"]) {
        value["__text"] = translate(value["__text"], langObj);
      }
      return value;
    })
  );
}

const langs = fs
  .readdirSync("./translations/", { withFileTypes: false })
  .filter(
    (x) => x.toLowerCase().endsWith(".js") && x.toLowerCase() !== "hashbrown.js"
  );

const baseGlade = fs.readFileSync(
  "./src/translations/hashbrown-thanked.glade",
  "utf8"
);

fs.copyFileSync(
  "./src/translations/hashbrown-thanked.glade",
  "./src/translations/hashbrown-en.glade"
);
console.log("Done with: en");

for (let i = 0; i < langs.length; i++) {
  const lang = require(`../../translations/${langs[i]}`);

  const document = parser.xml2js(baseGlade);

  const translatedGlade = scan(document, lang);

  const glade2XML =
    `<?xml version="1.0" encoding="UTF-8"?>` + parser.js2xml(translatedGlade);

  const langCode = langs[i].replace(/\.[^/.]+$/, "");

  fs.writeFileSync(
    "./src/translations/hashbrown-" + langCode + ".glade",
    glade2XML
  );

  console.log("Done with: " + langCode);
}

console.log("Finished creating translations!");
