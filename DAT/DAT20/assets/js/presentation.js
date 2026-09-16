/**
 * DAT20 Presentation Script Bridge
 * Spojení na centrální presentation-core.js v kořenové složce assets/
 */
(function () {
  'use strict';
  if (!window.PresentationFramework) {
    const coreScript = document.createElement('script');
    coreScript.src = '../../assets/js/presentation-core.js';
    document.body.appendChild(coreScript);
  }
})();
