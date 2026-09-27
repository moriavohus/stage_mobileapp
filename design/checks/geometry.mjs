import { chromium } from 'playwright';
const spec = [
 ['.page .chip:not(.chip--selected)','Chip Default',87,40],['.ds__item .button--primary:not(.button--small)','Button Primary L',107,50],['.ds__item .button--primary.button--small','Button Primary S',83,28],
 ['.button--plain','Button Plain L',59,50],
 ['.page .avatar','Avatar M',46,46],['.tab-item','Tab Item',77,58],['.layer-segment','Layer Segment',16,30],['.calendar-day','Calendar Day',44,52],
 ['.row-exercise','Row/Exercise',361,74],['.card-program','Card/Program',220,217],['.section-header','Section Header',361,46],['.row-list','Row/List',361,74],
 ['.row-setting','Row/Setting',361,52],['.note-why','Note/Why',321,70],['.stat-block','Stat Block',139,170],['.week-layers','Week Layers',136,30],
 ['.pearl-step','Pearl Step Day',72,102],['.community-post','Community Post',361,218],['.search-field','Search Field',361,48],
 ['.card-article--wide','Card/Article Wide',361,168],['.card-article--square','Card/Article Square',175,210],['.tile-domain','Tile/Domain',100,140],
 ['.card-photo--wide','Card/Photo Wide',361,300],['.card-photo--square','Card/Photo Square',175,298],['.ds__phone .tab-bar','Tab Bar',393,80],
 ['.ds__w361 .header-screen','Header/Screen None',361,50],['.card-today','Card/Today',361,318],['.card-knowledge','Card/Knowledge',361,254],
 ['.card-stat','Card/Stat Week',175,248],['.card-next','Card/Next Layer',175,242],['.card-core','Card/Core',361,216],['.card-growth','Card/Pearl Growth',361,296],
 ['.list-group--articles','List/Group Articles',361,307],['.list-group--settings','List/Group Settings',361,166],['.card-total','Card/Community Total',361,240],
 ['.hero-pearl','Hero/Pearl',361,356],['.grid-articles','Grid/Articles',361,790],['.card-calendar','Card/Calendar',361,432],
 ['.w-layer','W Layer of Day',364,383],['.w-today','W Today List',364,334],['.w-join','W Join',364,364],['.w-calendar','W Calendar',364,359],
 ['.w-phrase','W Phrase',180,170],['.w-pearl','W Pearl Glow',170,170],['.w-checkin','W Check-in',364,780],['.w-suggest','suggestions',369,348],['.ds__wide .nav-desktop','Nav/Desktop',1440,80],['.ds__wide .nav-desktop__container','Nav/Desktop Container',992,48]];
const b = await chromium.launch(); const p = await b.newPage({ viewport: { width: 1280, height: 900 } });
await p.goto((process.env.BASE_URL || 'http://localhost:3000') + '/design', { waitUntil: 'networkidle' });
let bad=0;
for (const [sel,name,w,h] of spec) { const r = await p.$eval(sel, e => { const b=e.getBoundingClientRect(); return [Math.round(b.width*10)/10, Math.round(b.height*10)/10]; }).catch(()=>null);
  const ok = r && Math.abs(r[0]-w)<=1.5 && Math.abs(r[1]-h)<=1.5; if(!ok) bad++;
  console.log((ok?'  ok ':'DIFF ')+name.padEnd(22)+' figma '+w+'×'+h+'  code '+(r?r.join('×'):'—')); }
console.log(bad+' diffs of '+spec.length); await b.close();
