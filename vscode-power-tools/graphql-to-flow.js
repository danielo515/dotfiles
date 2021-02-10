const cleanupFields = ["form", "name", "validate"];
const inputToSpring = (inputStr) => {
  return inputStr
    .replace(/Int!/g, "number,")
    .replace(/String!/g, "string,")
    .replace(/Time!/g, "Date,")
    .replace(/Boolean!/g, "bool,");
};
exports.execute = async (args) => {
  // args => https://egodigital.github.io/vscode-powertools/api/interfaces/_contracts_.workspacecommandscriptarguments.html

  // s. https://code.visualstudio.com/api/references/vscode-api
  const vscode = args.require("vscode");
  const editor = vscode.window.activeTextEditor;
  const selection = editor.selection;
  console.log(selection);
  editor.edit((builder) => {
    builder.replace(
      selection,
      inputToSpring(editor.document.getText(selection))
    );
  });

  vscode.window.showInformationMessage(`Ran the command`);
};
