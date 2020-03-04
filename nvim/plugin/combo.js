#!/usr/bin/env node

const [, , targetKey, ...keys] = process.argv;
if (keys.length <= 0) {
  console.error("Not enough arguments");
  process.exit(1);
}
const combo_enum=`${keys.join('_').toUpperCase()}`
const combo_name=`${keys.join('_')}_combo`
const real_keys=keys.map(k => `KC_${k.toUpperCase()}`)
const combo_definition = `const uint16_t PROGMEM ${combo_name}[]= {${real_keys.join(',')}, COMBO_END};`;
const combo_implementation = `[${combo_enum}] = COMBO(${combo_name}, KC_${targetKey.toUpperCase()}),`

console.log(`${combo_enum},`)
console.log(combo_definition);
console.log(combo_implementation)
