// @ts-check

const cleanupFields = ["form", "name", "validate"];
const resolversToStruct = (inputStr) => {
  const nameMatch = inputStr.match(/type (\w+) struct/);
  if (!nameMatch) throw new Error("No structure name found");
  const name = nameMatch[1];
  const fieldMatches = inputStr.matchAll(/^\s+(\w+)\s+([\w.]+)/gm);
  if (!fieldMatches) throw new Error("No fields selected");
  return [...fieldMatches]
    .map(
      (match) => `func (r *${name}) ${
        match[1][0].toUpperCase() + match[1].slice(1)
      }() ${match[2]}{
    return r.${match[1]}
  }`
    )
    .join("\n");
};
exports.execute = async (args) => {
  // args => https://egodigital.github.io/vscode-powertools/api/interfaces/_contracts_.workspacecommandscriptarguments.html

  // s. https://code.visualstudio.com/api/references/vscode-api
  const vscode = args.require("vscode");
  const editor = vscode.window.activeTextEditor;
  const selection = editor.selection;
  console.log(selection);
  const selectedText = editor.document.getText(selection);
  editor.edit((builder) => {
    builder.replace(
      selection,
      selectedText + "\n" + resolversToStruct(selectedText)
    );
  });

  vscode.window.showInformationMessage(`Ran the command`);
};
