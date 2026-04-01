import prettierConfig from './prettier.config.js';
import { createConfigForNuxt } from '@nuxt/eslint-config/flat';

export default await createConfigForNuxt({
  linting: true,
  formatting: prettierConfig,
});
