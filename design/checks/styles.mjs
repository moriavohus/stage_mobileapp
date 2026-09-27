import { chromium } from 'playwright';
const L='rgb(238, 234, 248)', LIME='rgb(247, 252, 219)', SKY='rgba(91, 124, 255, 0.08)', W='rgb(255, 255, 255)';
const IL='rgb(220, 209, 250) 0px 0px 4px 0px inset', ILI='rgb(221, 230, 138) 0px 0px 4px 0px inset', IS='rgba(91, 124, 255, 0.2) 0px 0px 4px 0px inset';
const spec=[['.chip:not(.chip--selected)',L,'40px',IL],['.chip--selected','rgb(0, 0, 0)','40px','none'],['.button--primary','rgb(26, 22, 51)','999px','none'],['.button--glass',L,'999px',IL],
 ['.row-exercise--lime .ios-row',LIME,'35px',ILI],['.row-exercise--sky .ios-row',SKY,'35px',IS],['.card-program--strength',SKY,'35px',IS],['.card-program--sleep',LIME,'35px',ILI],['.card-program--mind',L,'35px',IL],
 ['.note-why',W,'14px',ILI],['.community-post',L,'35px',IL],['.search-field',L,'999px',IL],['.card-article',L,'35px',IL],['.tile-domain',L,'30px',IL],['.card-photo',L,'35px',IL],['.card-photo__media',null,'30px',null],
 ['.ds__phone .tab-bar',W,'0px',IL],['.card-today',LIME,'40px',ILI],['.card-knowledge',L,'35px',IL],['.card-stat',L,'35px',IL],['.list-group',L,'35px',IL],['.card-calendar',L,'35px',IL],
 ['.w-join',L,'40px',IL],['.w-calendar',L,'40px',IL],['.w-phrase',L,'40px',IL],['.w-pearl',LIME,'40px',ILI],['.w-today__sheet',W,'30px',IL],['.w-layer__sheet',W,'30px','none'],['.w-checkin__tile',L,'24px',IL],['.w-suggest__mood',W,'999px',IL],
 ['.layer-segment:not(.layer-segment--empty)','rgb(85, 60, 163)','8px','rgba(255, 255, 255, 0.7) 0px 1px 0px 0px inset'],['.calendar-day--today .calendar-day__circle','rgb(26, 22, 51)','999px',null]];
const fonts=[['.text-title-section','270','"wdth" 132','28px'],['.text-display-xl','410','"wdth" 132','64px'],['.text-body-l','400','"wdth" 100','17px'],['.text-body-l-strong','510','"wdth" 100','17px']];
const b=await chromium.launch(); const p=await b.newPage({viewport:{width:1280,height:900}}); await p.goto((process.env.BASE_URL || 'http://localhost:3000') + '/design',{waitUntil:'networkidle'});
let bad=0;
for(const [s,bg,r,sh] of spec){ const c=await p.$eval(s,e=>{const x=getComputedStyle(e);return [x.backgroundColor,x.borderTopLeftRadius,x.boxShadow]}); const ok=(bg==null||c[0]===bg)&&c[1]===r&&(sh==null||c[2]===sh); if(!ok){bad++;console.log('DIFF',s,JSON.stringify(c));} }
for(const [s,w,v,fs] of fonts){ const c=await p.$eval(s,e=>{const x=getComputedStyle(e);return [x.fontWeight,x.fontVariationSettings,x.fontSize]}); if(c[0]!==w||c[1]!==v||c[2]!==fs){bad++;console.log('DIFF',s,c);} }
console.log(bad+' style diffs of '+(spec.length+fonts.length)); await b.close();
