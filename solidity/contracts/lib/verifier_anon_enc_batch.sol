// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier_AnonEncBatch {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 20491192805390485299153009773594534940189261866228447918068658471970481763042;
    uint256 constant alphay  = 9383485363053290200918347156157836566562967994039712273449902621266178545958;
    uint256 constant betax1  = 4252822878758300859123897981450591353533073413197771768651442665752259397132;
    uint256 constant betax2  = 6375614351688725206403948262868962793625744043794305715222011528459656738731;
    uint256 constant betay1  = 21847035105528745403288232691147584728191162732299865338377159692350059136679;
    uint256 constant betay2  = 10505242626370262277552901082094356697409835680220590971873171140371331206856;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant deltax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant deltay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant deltay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;

    
    uint256 constant IC0x = 18580313005843130750897171718145080482235072131569730259957978577748570559649;
    uint256 constant IC0y = 11008887417210438536585448513758116701594184516218266767200382038698657764221;
    
    uint256 constant IC1x = 10395455187749871152883464021307305039211351581687979783405361207037728300193;
    uint256 constant IC1y = 11600915897800791538290922796324375639045246774375030019235967800001631056081;
    
    uint256 constant IC2x = 19012918149126703267663593445808175619480893261454622174940060826375314872156;
    uint256 constant IC2y = 17292336586116381783624259876837450266737198173900937538650199584511449644435;
    
    uint256 constant IC3x = 4019137029405419097267801088312523285238891636115679173603315739468427252747;
    uint256 constant IC3y = 15809545958206039472783912362667444249113343409085595869382050690665993502050;
    
    uint256 constant IC4x = 14872887748100989828841255841897557661988963843773440593461687004862289568357;
    uint256 constant IC4y = 707264018499155351153144909653994994003834790710696804648109563993025943366;
    
    uint256 constant IC5x = 16514496054640308404323890294088865968089714028777208291765274441332074171864;
    uint256 constant IC5y = 12769219872332104583750516550260785834899303444511175589424170196695435680484;
    
    uint256 constant IC6x = 13905557825606788993678073885934030632306346259739236330021528211041430955807;
    uint256 constant IC6y = 19723644376451716571992106547505336259465112950673654358978326957992400044064;
    
    uint256 constant IC7x = 8264179395231575277465933874879987694885169362396639992636472287793251648110;
    uint256 constant IC7y = 12443896788758655422719991504651147026633647705033180775565654824821165943059;
    
    uint256 constant IC8x = 8485997154444365276896303456998622212811060075371960245510349137643960424870;
    uint256 constant IC8y = 18971147756928463123988104069945090628663771220036193309677633655768176076195;
    
    uint256 constant IC9x = 869560992511000659737335884703209813934230477310115975214517656512595861513;
    uint256 constant IC9y = 9440747965374440518266156764920008655009007660780695002896691660548324902543;
    
    uint256 constant IC10x = 10075513747277939401510923250892109501000746804932194878164209575250161086192;
    uint256 constant IC10y = 19463677239853278508101060261048204446854474135414502347125196265634997978764;
    
    uint256 constant IC11x = 18142247304487015474279350674984581244759430901903684804824817386897842183762;
    uint256 constant IC11y = 16815230776141141852416945385119180374500213595674994163238538349964439222987;
    
    uint256 constant IC12x = 11173485235242420725718659527560300597035854993339606351659335933202050850095;
    uint256 constant IC12y = 3125389301302239565023836651248446337674097036446323994003684725538892424465;
    
    uint256 constant IC13x = 5788036546752129523637322954624353970609666772643743143540775085934828808105;
    uint256 constant IC13y = 12277669483316224305786225647398134683815519587025778198432062773479356824943;
    
    uint256 constant IC14x = 18692434997265253699869020953988292539050476952423685004923557500376133891742;
    uint256 constant IC14y = 342551473749691784471223997799655831725308362523273866230277014675082573920;
    
    uint256 constant IC15x = 3084040488617678634451034700902142302706785800905803615641290997372934039629;
    uint256 constant IC15y = 10352212961548725454680748878102714505537073915328544331973751367411853517968;
    
    uint256 constant IC16x = 8815590700156507188706372103260708008503819884595719208068957182594452382706;
    uint256 constant IC16y = 14307813698620902210202388952960096592994921369112382398769010587673674870895;
    
    uint256 constant IC17x = 19682561076054123708343034072843126868926418055716702330253403823575454770590;
    uint256 constant IC17y = 18202466752687940422307455551927513340705521678216830096984410951222811772372;
    
    uint256 constant IC18x = 18079786686719226777418719106451592827293061587859022084550603811634293825186;
    uint256 constant IC18y = 16750707160442793558759266863875270266277084671857633225929130812325912806581;
    
    uint256 constant IC19x = 7839704593259956918939767683000068050930985837516647710445231902435800918759;
    uint256 constant IC19y = 891599776938399280676377598206746048465280324223262253957040578750254407865;
    
    uint256 constant IC20x = 13445491457521330603121496349061226145494025993330948749299051234657497510253;
    uint256 constant IC20y = 10848448834616010506430415115856238655344059072832369239747154158784165380574;
    
    uint256 constant IC21x = 3034026451356886975121848548035566962951364895066675787683728668537065084913;
    uint256 constant IC21y = 18115850563760447810677720398359362283046191905462848606359835630677403370860;
    
    uint256 constant IC22x = 18290750884832548296973183452882808030816922576455927178515381877994640281090;
    uint256 constant IC22y = 14100083568683442600810755492817047713951946261147225265199706432643775440434;
    
    uint256 constant IC23x = 11960161265227847978578800186220836932179471295357657053427141622013030927719;
    uint256 constant IC23y = 14193496910420947149336822166949074211001309021624854090710003301669740014614;
    
    uint256 constant IC24x = 7779798651792299800720258938406055167179480947180721391877922814033001105201;
    uint256 constant IC24y = 17376322472933947095338187051436508851173303005179012866936647440368262750618;
    
    uint256 constant IC25x = 3888850493135703018846205869686083045811093602466434460731653424931761326221;
    uint256 constant IC25y = 6269537785789749249629168156706952756212254395547088941173798585144723331476;
    
    uint256 constant IC26x = 2624068077607055390692560935955875069652950189114572026383801229012281774312;
    uint256 constant IC26y = 19336408024454147351672765601958115241727634745063647520918252448629844714864;
    
    uint256 constant IC27x = 573279682226446286836562627953090350715956932874026047431522511730787917246;
    uint256 constant IC27y = 14230584629774323911176258089456481563945539046203627005053099682053589731814;
    
    uint256 constant IC28x = 4511570098943154775995495148771492291351043024536238686913034352965916533125;
    uint256 constant IC28y = 2340031054291940797267154240028305737245337594820544906593280764149065244825;
    
    uint256 constant IC29x = 4244298795288442828475342316585381618978030590322384652198362345941312928633;
    uint256 constant IC29y = 9438334411692417939374968865080847314521367958416311859692108859103781907941;
    
    uint256 constant IC30x = 17737337973100087486003606060674946694260132465844404962845799719962917758973;
    uint256 constant IC30y = 7438304997446447325381090274100267847876769794265566934283357638123761255667;
    
    uint256 constant IC31x = 5073846234920030162386412921623356988171236970692204160050544014274745465059;
    uint256 constant IC31y = 14677270458799791786755022443638092287691886421830047066112814404323133288440;
    
    uint256 constant IC32x = 2649033681819263291861473051971051186343759522480686104149113115044924128944;
    uint256 constant IC32y = 368561605425021272655590601170158268253924682190949619461929724301292551015;
    
    uint256 constant IC33x = 2733062167495935733708948948866685430872554261586995026969550966429718566022;
    uint256 constant IC33y = 6411816009368917331257762188881602672445994519737090781581495901122113461081;
    
    uint256 constant IC34x = 20250160139583654384387041345707174206762761262409783484616912329425844084625;
    uint256 constant IC34y = 19016558756523986455860206302819973524969128216062592778785213073674762867523;
    
    uint256 constant IC35x = 15894959450212660445607057078230066935166933771906424199978970131827817403090;
    uint256 constant IC35y = 10045299443552736874341712125430822824696482027842940080732022345835796014058;
    
    uint256 constant IC36x = 19067063999171834146975963353534064225201820362410195192049051511782751195044;
    uint256 constant IC36y = 2506495847834216106513947518784734886166637826583036171765097900048189049388;
    
    uint256 constant IC37x = 20048423250126485298790599458080889503743390991035522140783547095481863739847;
    uint256 constant IC37y = 432499433100169474280343727517209507946637100968553874268405765061538477445;
    
    uint256 constant IC38x = 4484001954171890993129130178754704164281480451053104064984831605862602260258;
    uint256 constant IC38y = 7759398357222525722136480306881167291726062747218708405778490387263694708092;
    
    uint256 constant IC39x = 9879417966637100676391650403146342713449629632519434140235680754294946551949;
    uint256 constant IC39y = 15451915567461765109128586274365779761014171030437692494597946077719634133869;
    
    uint256 constant IC40x = 18015815737895485624311190888781881473280290704069209472984130604071174626458;
    uint256 constant IC40y = 20571471454036622825620290594405505910463099932329480776779858769691471312936;
    
    uint256 constant IC41x = 14112557685614179038383128489280480211113230260897628782350879610506723066296;
    uint256 constant IC41y = 4625717768090043519906775978425574543701446953863907012515553618711405705039;
    
    uint256 constant IC42x = 4983395328156700782015316268806625602806315033043189097352204763000436518560;
    uint256 constant IC42y = 19482783890487649350151682111521490854662824643737828880902462296743530267628;
    
    uint256 constant IC43x = 21633845127215409049488491876378438089702751885988973713465151949792257474714;
    uint256 constant IC43y = 4371850726978329918834280756138306161054656307479387812738196935174831422645;
    
    uint256 constant IC44x = 2548882568327324055111599210300480241321372701942701377576348328402662866139;
    uint256 constant IC44y = 4524021331764945409786735318785913263007209055921801384420761006536725314685;
    
    uint256 constant IC45x = 19659391908153913811596124442049624885170131973489352829333546344553135257510;
    uint256 constant IC45y = 16656715280271362420772172624260010221348141492431711855276122544565474520702;
    
    uint256 constant IC46x = 8896984418633548964127728431478188318864199890855270550143492636924721511210;
    uint256 constant IC46y = 6919482284828007839477398069876856393249650014212985389404248094124722915240;
    
    uint256 constant IC47x = 6518290439017095560691399852424249132778068085813366319163817711881824409791;
    uint256 constant IC47y = 3284685835801965119116146561092439174219777476240058235867822621338673579331;
    
    uint256 constant IC48x = 8033604856053776244250552744122408354496130970096388922815908609048973073414;
    uint256 constant IC48y = 8336855926902257978469622445918692362344917252278601299635228486345513119588;
    
    uint256 constant IC49x = 762719527935435450516891704363874770750583859888948178357853607647175574612;
    uint256 constant IC49y = 8256041118766190616011652913286853532083118591061155675870667840754356402534;
    
    uint256 constant IC50x = 16686189358510727991101848152813188162502396281005620677822213040498626183631;
    uint256 constant IC50y = 13510853093329976521861634140640716845068141465351777749353954827649112591159;
    
    uint256 constant IC51x = 20863154444170938062541635700383799267943965694931673908472103491360316658198;
    uint256 constant IC51y = 8047896606703175255524543937848475341214773991450368177617603514417408284270;
    
    uint256 constant IC52x = 4047537306843338107901229832168496874090806043500283381615935615881345211899;
    uint256 constant IC52y = 12790093502738348919276084773794473095147923720873582923150684934895855964843;
    
    uint256 constant IC53x = 7330815624523775722379710936527938383081945716002232059659696872814735920048;
    uint256 constant IC53y = 11025097549787579052576667472578692374447143298962823741805882088598771978547;
    
    uint256 constant IC54x = 6231008058243754325016081071935251733134866552710735080928614245502954021040;
    uint256 constant IC54y = 7318863159203743682119100550284270125004015068001103343401793604986091890654;
    
    uint256 constant IC55x = 21158029041222423410043352319174457316558083678598576072929387420624163192416;
    uint256 constant IC55y = 5531279798799451796652659709739245849351203722729011301214119743849653788069;
    
    uint256 constant IC56x = 12014862035046951355101419994223969637282254292721192822372859423245150445446;
    uint256 constant IC56y = 2311764065876764832527366306553093967932622817497205041098152431617162581353;
    
    uint256 constant IC57x = 21695280614967710084389748570241416093602962398056849805774508816194950194787;
    uint256 constant IC57y = 18191654181966122754741527150719336027917617691575071992794751979286395392305;
    
    uint256 constant IC58x = 21047846330841419928502996231645927247655382607859750880249123377525227364150;
    uint256 constant IC58y = 8402491704424326339367963738500912842656389498202887832115378169344708513916;
    
    uint256 constant IC59x = 16344244402028661110837125795426397906771725930572024004274316943323997456523;
    uint256 constant IC59y = 21727029327269051634516907877146408348576114856630675172891629001833243048204;
    
    uint256 constant IC60x = 1519932788273488551267386972646448462828859765352364410394075676949554336196;
    uint256 constant IC60y = 1979959948671052063532067178298821868327541781645157457232819226861627360091;
    
    uint256 constant IC61x = 15851885538948597596279699719636980170694995391190241940432604960671958363820;
    uint256 constant IC61y = 16395946444733592540419673435491743548984853080511400784779076941597452257989;
    
    uint256 constant IC62x = 15892532567883815305704420388191894385518913231207078932648068055695706659905;
    uint256 constant IC62y = 19847117276181937517962758799664161738662138368350262518470665046389125666410;
    
    uint256 constant IC63x = 5666231684381871047335202691615462369540432942935744756615905034997241358593;
    uint256 constant IC63y = 4517591676128014860099623345457663896060365914890087331336249141431435990057;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[63] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, r)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                
                g1_mulAccC(_pVk, IC32x, IC32y, calldataload(add(pubSignals, 992)))
                
                g1_mulAccC(_pVk, IC33x, IC33y, calldataload(add(pubSignals, 1024)))
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                
                g1_mulAccC(_pVk, IC37x, IC37y, calldataload(add(pubSignals, 1152)))
                
                g1_mulAccC(_pVk, IC38x, IC38y, calldataload(add(pubSignals, 1184)))
                
                g1_mulAccC(_pVk, IC39x, IC39y, calldataload(add(pubSignals, 1216)))
                
                g1_mulAccC(_pVk, IC40x, IC40y, calldataload(add(pubSignals, 1248)))
                
                g1_mulAccC(_pVk, IC41x, IC41y, calldataload(add(pubSignals, 1280)))
                
                g1_mulAccC(_pVk, IC42x, IC42y, calldataload(add(pubSignals, 1312)))
                
                g1_mulAccC(_pVk, IC43x, IC43y, calldataload(add(pubSignals, 1344)))
                
                g1_mulAccC(_pVk, IC44x, IC44y, calldataload(add(pubSignals, 1376)))
                
                g1_mulAccC(_pVk, IC45x, IC45y, calldataload(add(pubSignals, 1408)))
                
                g1_mulAccC(_pVk, IC46x, IC46y, calldataload(add(pubSignals, 1440)))
                
                g1_mulAccC(_pVk, IC47x, IC47y, calldataload(add(pubSignals, 1472)))
                
                g1_mulAccC(_pVk, IC48x, IC48y, calldataload(add(pubSignals, 1504)))
                
                g1_mulAccC(_pVk, IC49x, IC49y, calldataload(add(pubSignals, 1536)))
                
                g1_mulAccC(_pVk, IC50x, IC50y, calldataload(add(pubSignals, 1568)))
                
                g1_mulAccC(_pVk, IC51x, IC51y, calldataload(add(pubSignals, 1600)))
                
                g1_mulAccC(_pVk, IC52x, IC52y, calldataload(add(pubSignals, 1632)))
                
                g1_mulAccC(_pVk, IC53x, IC53y, calldataload(add(pubSignals, 1664)))
                
                g1_mulAccC(_pVk, IC54x, IC54y, calldataload(add(pubSignals, 1696)))
                
                g1_mulAccC(_pVk, IC55x, IC55y, calldataload(add(pubSignals, 1728)))
                
                g1_mulAccC(_pVk, IC56x, IC56y, calldataload(add(pubSignals, 1760)))
                
                g1_mulAccC(_pVk, IC57x, IC57y, calldataload(add(pubSignals, 1792)))
                
                g1_mulAccC(_pVk, IC58x, IC58y, calldataload(add(pubSignals, 1824)))
                
                g1_mulAccC(_pVk, IC59x, IC59y, calldataload(add(pubSignals, 1856)))
                
                g1_mulAccC(_pVk, IC60x, IC60y, calldataload(add(pubSignals, 1888)))
                
                g1_mulAccC(_pVk, IC61x, IC61y, calldataload(add(pubSignals, 1920)))
                
                g1_mulAccC(_pVk, IC62x, IC62y, calldataload(add(pubSignals, 1952)))
                
                g1_mulAccC(_pVk, IC63x, IC63y, calldataload(add(pubSignals, 1984)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            
            checkField(calldataload(add(_pubSignals, 704)))
            
            checkField(calldataload(add(_pubSignals, 736)))
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            
            checkField(calldataload(add(_pubSignals, 992)))
            
            checkField(calldataload(add(_pubSignals, 1024)))
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            
            checkField(calldataload(add(_pubSignals, 1152)))
            
            checkField(calldataload(add(_pubSignals, 1184)))
            
            checkField(calldataload(add(_pubSignals, 1216)))
            
            checkField(calldataload(add(_pubSignals, 1248)))
            
            checkField(calldataload(add(_pubSignals, 1280)))
            
            checkField(calldataload(add(_pubSignals, 1312)))
            
            checkField(calldataload(add(_pubSignals, 1344)))
            
            checkField(calldataload(add(_pubSignals, 1376)))
            
            checkField(calldataload(add(_pubSignals, 1408)))
            
            checkField(calldataload(add(_pubSignals, 1440)))
            
            checkField(calldataload(add(_pubSignals, 1472)))
            
            checkField(calldataload(add(_pubSignals, 1504)))
            
            checkField(calldataload(add(_pubSignals, 1536)))
            
            checkField(calldataload(add(_pubSignals, 1568)))
            
            checkField(calldataload(add(_pubSignals, 1600)))
            
            checkField(calldataload(add(_pubSignals, 1632)))
            
            checkField(calldataload(add(_pubSignals, 1664)))
            
            checkField(calldataload(add(_pubSignals, 1696)))
            
            checkField(calldataload(add(_pubSignals, 1728)))
            
            checkField(calldataload(add(_pubSignals, 1760)))
            
            checkField(calldataload(add(_pubSignals, 1792)))
            
            checkField(calldataload(add(_pubSignals, 1824)))
            
            checkField(calldataload(add(_pubSignals, 1856)))
            
            checkField(calldataload(add(_pubSignals, 1888)))
            
            checkField(calldataload(add(_pubSignals, 1920)))
            
            checkField(calldataload(add(_pubSignals, 1952)))
            
            checkField(calldataload(add(_pubSignals, 1984)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
