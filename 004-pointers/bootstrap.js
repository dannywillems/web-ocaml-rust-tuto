// Required!!!! See https://github.com/webpack/webpack/issues/6615#issuecomment-668177931

import("./ocaml/_build/default/src/lib.js").catch(e =>
    console.error("Error importing `lib.js`:", e)
);