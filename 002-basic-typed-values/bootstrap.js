// Required!!!! See https://github.com/webpack/webpack/issues/6615#issuecomment-668177931

import("./ocaml/_build/default/src/typed_values.js").catch(e =>
    console.error("Error importing `typed_values.js`:", e)
);