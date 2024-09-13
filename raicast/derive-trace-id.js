#!/usr/bin/env node

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title derive trace id
// @raycast.mode fullOutput

// Optional parameters:
// @raycast.icon 🤖
// @raycast.argument1 { "type": "text", "placeholder": "any string" }
// @raycast.packageName danielo515

// Documentation:
// @raycast.description given any text, computes the traceid
// @raycast.author danielo
// @raycast.authorURL https://raycast.com/danielo.es
const crypto = require('crypto')
const [text] = process.argv.slice(2)

function deriveHexString(input, desiredLength) {
  const hash = crypto.createHash("sha256").update(input).digest("hex");
  return hash.slice(0, desiredLength);
}

console.log(deriveHexString(text, 32))
