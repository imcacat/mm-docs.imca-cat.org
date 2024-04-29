module.exports = {
    languageOptions: {
        ecmaVersion: 2022, // specify the ECMAScript version you are using
        sourceType: 'module', // set to 'module' if using ES6 modules, otherwise 'script'
        globals: {
            window: 'readonly', // If using browser environment
            document: 'readonly', // If using browser environment
            process: 'readonly', // If using Node.js environment
            console: 'readonly' // If console statements are used
        }
    },

    // `extends` provides a way to apply a set of predefined rules. These rules can be configurations recognized by ESLint.
    extends: [
        "eslint:recommended", // Adds all the recommended rules by ESLint (common best practices).
        "plugin:prettier/recommended" // Integrates Prettier for code formatting and disables ESLint rules that might conflict with Prettier.
    ],

    // Defines specific parser options
    parserOptions: {
        ecmaVersion: 2022,
        sourceType: "module"
    },

    // `rules` allows you to define specific rules.
    rules: {
        "eqeqeq": ["error", "always"], // Enforces strict equality
        "no-unused-vars": ["error", { "args": "after-used" }], // Disallows unused variables except for function arguments used after the last used argument
        "no-console": "error", // Disallows the use of console.log() and similar methods in production code
        "complexity": ["error", 10], // Sets a cyclomatic complexity threshold
        "no-implicit-globals": "error" // Disallows variable and function declarations in the global scope
    },

    // `overrides` can specify different settings for specific file types
    overrides: [
        {
            files: ["*.js", "*.jsx"],
            rules: {
                "react/jsx-uses-react": "error",
                "react/jsx-uses-vars": "error"
            }
        }
    ],

    // Specifies files and patterns to ignore
    ignorePatterns: ["node_modules/"],

    // Specifies ESLint plugins
    plugins: [
        "prettier" // Uses Prettier plugin
    ]
};
