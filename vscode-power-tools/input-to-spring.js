const cleanupFields = ["form", "name", "validate"];
const inputToSpring = (inputStr) => {
  const name = inputStr.match(/name=["\{}]\w+["\}]/)[0];
  const validation = (inputStr.match(/validate=["\{}][^"\}]+["\}]/) || [])[0];
  return `{...field({ ${name.replace("=", ": ").replace(/[\{/}]/g, "")}  ${
    validation
      ? `,  ${validation.replace("ate=", "ation: ").replace(/[\{/}]/g, "")}`
      : ""
  }})}\n${inputStr.replace(
    new RegExp(`^ *(${cleanupFields.join("|")}).*$`, "mg"),
    ""
  )}`;
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
