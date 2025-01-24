import globals from "globals";
import pluginJs from "@eslint/js";

/** @type {import('eslint').Linter.Config[]} */
export default [
  {
    languageOptions: { 
      globals: globals.browser,
      parserOptions: {
        ecmaVersion: 'latest',
      }
    },
    rules: {
      'semi': ['error', 'always'],
      'no-unused-vars': 'warn',
      'eqeqeq': 'error',
      'space-before-function-paren': ['error', 'always'],
      'space-infix-ops': 'error'
    }
  },
  pluginJs.configs.recommended,
];