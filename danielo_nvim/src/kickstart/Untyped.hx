package kickstart;

class Capabilities {
  // TODO: do not use untyped
  public static function getCapabilities() {
    final capabilities = untyped __lua__("vim.lsp.protocol.make_client_capabilities()");
    return untyped __lua__("require('cmp_nvim_lsp').default_capabilities({0})", capabilities);
  }
}
