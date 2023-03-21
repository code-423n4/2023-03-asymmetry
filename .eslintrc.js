module.exports = {
  env: {
    browser: false,
    es2021: true,
    mocha: true,
    node: true,
  },
  plugins: ["@typescript-eslint", "prettier"],
  extends: [
    "standard",
    "plugin:prettier/recommended",
    "plugin:node/recommended",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    ecmaVersion: 12,
  },
  ignorePatterns: ["node_modules/*", "coverage/*"],
  rules: {
    "node/no-unpublished-import": 0,
    "node/no-missing-import": 0,
    "no-process-exit": 0,
    "node/no-unsupported-features/es-syntax": [
      "error",
      { ignores: ["modules"] },
    ],
    "prettier/prettier": ["error"],
  },
};
