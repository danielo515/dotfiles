# bun completions
[ -s "/Users/danielo/.bun/_bun" ] && source "/Users/danielo/.bun/_bun"
# pnpm
export PNPM_HOME="/Users/danielo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end%                                                                                                                                                                                                              
