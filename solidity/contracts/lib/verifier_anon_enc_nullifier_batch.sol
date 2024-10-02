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

contract Groth16Verifier_AnonEncNullifierBatch {
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

    
    uint256 constant IC0x = 15541712691897739747724830300506738262081962743737466099607307479041362351151;
    uint256 constant IC0y = 15309799118687561062851562419208761963425326551696680678239287738208909024469;
    
    uint256 constant IC1x = 12004066118121267476589554896909877287920971467382352176843746954792752500122;
    uint256 constant IC1y = 7206764879432615417714949819409956497578875830297354760497237983805982197325;
    
    uint256 constant IC2x = 799639163124225172098935137771473826429681232551382892742052034006481996153;
    uint256 constant IC2y = 19460212393596922532627580662240966771232896727700198582151473552927560553889;
    
    uint256 constant IC3x = 18044350123603547886233505234824835771276375069050425360565411842776328391967;
    uint256 constant IC3y = 1576307986547670127474732693850143662396449202007408662651643215890624339590;
    
    uint256 constant IC4x = 20400451647704478477749132993829457719981743294312779765310610728208160269079;
    uint256 constant IC4y = 13745658125866723760491826360953130191933571020637214849003136419490483471618;
    
    uint256 constant IC5x = 21648241602395290828104735702321830963639705642419053639842578212816043889120;
    uint256 constant IC5y = 10179313856185307487415998272527907126366740786494446493789947311539305678053;
    
    uint256 constant IC6x = 3266888133196656674176137519937215957510568740238920535204121170594142622560;
    uint256 constant IC6y = 581807064662727539042969124018393695993024464972930142746805292963483764953;
    
    uint256 constant IC7x = 5782731932588123426638937014276981925622231980747761293158670051075134173058;
    uint256 constant IC7y = 458530253552218801975310357315165518597333443362171356430274561658414761950;
    
    uint256 constant IC8x = 548417836864289418463262487062535242640735442612835114756201932820067573481;
    uint256 constant IC8y = 2725681563128474659874007033711084055442148149698768488522707436838354023653;
    
    uint256 constant IC9x = 8616702659111468433065736804187627618320987671315404885064661690736085080484;
    uint256 constant IC9y = 7087234574242487191257150935672471494420269714381737926190856770920046787505;
    
    uint256 constant IC10x = 20167815511788284222998097079028719792269656943773089939369231400752958985405;
    uint256 constant IC10y = 9404517860139883423870033333986444177106503920145114499080334948982539603563;
    
    uint256 constant IC11x = 1225817578886650460062531786383208026059122829420759086444588384070049592508;
    uint256 constant IC11y = 11517528485210636107743904361440850052045320470911699770542860487162122450992;
    
    uint256 constant IC12x = 17670597734429577409649305751860763996652171996727040662400736475421233889240;
    uint256 constant IC12y = 17738127465063980814155958209108854058529581644039192769715341582606425405655;
    
    uint256 constant IC13x = 929501530331525055050523975910356956002521580711546356352545747027797467464;
    uint256 constant IC13y = 13640717087941957737899250122156624646568466250990204802363767034434488937293;
    
    uint256 constant IC14x = 18848953267508570424067614897329234899322972096731866125127364941150981569281;
    uint256 constant IC14y = 20823402513185587475650998954455654732818037454973951576534750188849254169455;
    
    uint256 constant IC15x = 1500916762917981320137086365080717319893029971740154971104077473585000855704;
    uint256 constant IC15y = 16450861685356903953750824971500662259636788991629523821174021104020823271668;
    
    uint256 constant IC16x = 7896452761877752610994779284082958157057343429510624631113102306128671104330;
    uint256 constant IC16y = 11835738009486031602232155722324145803064919243303340007952171062163921173904;
    
    uint256 constant IC17x = 10025475874790213804420276568943869945361292747999892043167699468353487701613;
    uint256 constant IC17y = 5107313052045121773802855222374277248047247722671994362633810734440920871478;
    
    uint256 constant IC18x = 19945822408866478915965045838495679811500722732215092398900155158736008963418;
    uint256 constant IC18y = 13773067490301179219537121121299653350694808450630171555491523667462586880278;
    
    uint256 constant IC19x = 4763437325608066345807300028857485637369762732123976021601638339153509382024;
    uint256 constant IC19y = 5047697368859449964614854146008748593463758126500575129574554875185564520393;
    
    uint256 constant IC20x = 19142875394805921284571633134030409276483104720336088876339486260571557017538;
    uint256 constant IC20y = 20255895849223763729597350362071522806384158657022013733318416119165993678780;
    
    uint256 constant IC21x = 2389668560232905520261975748906012326901650226854014060862917742678195465447;
    uint256 constant IC21y = 1899098024654651685978763707976166438522410162625384041320426996598176775065;
    
    uint256 constant IC22x = 6468619651569256820909467366831560164190083450291238480576398203441710278018;
    uint256 constant IC22y = 16494512224582383876680610529582940807905463103020385179212536970251178153298;
    
    uint256 constant IC23x = 6792394873949265205498601290765446513706573500098286743228958428707859264887;
    uint256 constant IC23y = 3135195861055228915763886314109310178681888946796444049220917208236247667817;
    
    uint256 constant IC24x = 9266604700268833025757822337601913610118953450980230617421387823387114321039;
    uint256 constant IC24y = 684776033451391807773496036368435775473676587377239740534880627484043892051;
    
    uint256 constant IC25x = 6905787635551118817416367019947024312211514839412196182473354054946296976287;
    uint256 constant IC25y = 9073773280350094183697313232253045968953858264899014207423369407816895664304;
    
    uint256 constant IC26x = 13306637200231533830503220504568727374426654473422967256521181232143642535746;
    uint256 constant IC26y = 9905287965352985711803653987262566304924826103036042068850824213540722333093;
    
    uint256 constant IC27x = 13975571818634919306071529987892580265578815964293765017855321641621531903221;
    uint256 constant IC27y = 5300859849766378300999776680322915197886702696720082887610869004009914021574;
    
    uint256 constant IC28x = 15461548506058574530210271008631392910173946216984069691869311297773744026787;
    uint256 constant IC28y = 13706208504159530911524812257232455305935489038658391834074042379348195879714;
    
    uint256 constant IC29x = 8730611225090083996184886288677544700541764038521483864314195520451147229096;
    uint256 constant IC29y = 11247481622713393315035873003152287222935085324856747705316784771296595673366;
    
    uint256 constant IC30x = 12650481169811028554568125651506265674590913621862836202688125356346247992372;
    uint256 constant IC30y = 11452734649780361705780105715683639426183710853645312057068180259423538723332;
    
    uint256 constant IC31x = 18801255147353589786966703415517609079978518336487219754042258413444127518119;
    uint256 constant IC31y = 19893166553319303558130971297012299399136641547281031132305685314905030998930;
    
    uint256 constant IC32x = 10511687321004525154566058994742879585718001333240678753787240216198612873446;
    uint256 constant IC32y = 21035585223167373046736315494645287448501555304653780177687173952982331918799;
    
    uint256 constant IC33x = 7272484077050364841806145255927549145744398473472937793159247950835711431776;
    uint256 constant IC33y = 3332943818971710197352806450726589823168559481693067793695706760634701210734;
    
    uint256 constant IC34x = 12398213457650840610919110725829163032033234989484701088276123492267294936747;
    uint256 constant IC34y = 4259608936469531783501826512477567753342186953120203533262526878892490390409;
    
    uint256 constant IC35x = 4238837052442157737602628064961876774504833160472421163269905967426095404243;
    uint256 constant IC35y = 21848250279969602266847007164039196603684130099783052248041812103563139729559;
    
    uint256 constant IC36x = 8492386204394865359133830740481874229340648359828275939759590994351412630307;
    uint256 constant IC36y = 13755056518831659966384164241356011630642775799391196790093432317593236841492;
    
    uint256 constant IC37x = 18652871069353668812559074416592618031978091090456771959148689261399017168933;
    uint256 constant IC37y = 15197528527915159071043184850412060787519053445044144817887906567947217106528;
    
    uint256 constant IC38x = 18242990479342094711988513795259571447690442758966541403071663580322034914731;
    uint256 constant IC38y = 4694277002709134888384606306080013611889134864643132473497507757053371561787;
    
    uint256 constant IC39x = 1301764858559868397372439245835039661364048076417031411065499735289989905777;
    uint256 constant IC39y = 21374552920703964634170919159603713823469086788065336308759639968042414346907;
    
    uint256 constant IC40x = 5703909713412030602521704551948720598115811456049201510641793049756078930084;
    uint256 constant IC40y = 11343360379848634277868929278610347535014796127961282265684057695864199303693;
    
    uint256 constant IC41x = 21676266146672888828908790051178127819023353821226367259237036360300088838150;
    uint256 constant IC41y = 20282295604827307954821629408550991162593461788632176338109233694336422372280;
    
    uint256 constant IC42x = 15900351677039192970235086696274291816056092279722947753810633865422331110510;
    uint256 constant IC42y = 7552633138863201012843937997990540379972533897372099813912374675845082336737;
    
    uint256 constant IC43x = 16986114726426059742163302482011322086275381379115213583913103602213591705633;
    uint256 constant IC43y = 923269388364919243684772277727900792509753326830815519333165313425426159812;
    
    uint256 constant IC44x = 18186660967945754210000520490901640298568718480270307043999757416860784824435;
    uint256 constant IC44y = 2504159044950004032445503102664948854687012926668096130852117535309632169266;
    
    uint256 constant IC45x = 4991552688486276616511273377000905780037528993680569787454736501968017275936;
    uint256 constant IC45y = 20329730207244190194399341946823927144025883223552266872518685163447033251710;
    
    uint256 constant IC46x = 15588669292822971027212746772468059587153741804272380842071129604935726444761;
    uint256 constant IC46y = 13246615605370923171385971348275178771325109931221712502857728544047515567676;
    
    uint256 constant IC47x = 14296275320715004191013745886745046991602044572941193816257113343670653624832;
    uint256 constant IC47y = 2601284390982903491762982344917578099649417178108163508683943707962860500350;
    
    uint256 constant IC48x = 16950244266549700135382898829621258093653503205489322996191500320120085510969;
    uint256 constant IC48y = 6966954670688364311601206395118660404689846194634462521411331768192803520094;
    
    uint256 constant IC49x = 1793479366619778804560203910817313900980767350800954690294822254090714032064;
    uint256 constant IC49y = 1048215802761854722044182044883578100910289257829996092498059084505962374306;
    
    uint256 constant IC50x = 13856521648827555085850487426366910290801355375443444343366086110228301059830;
    uint256 constant IC50y = 535324682486169534839214155712250670348408259872174356460556327634867645044;
    
    uint256 constant IC51x = 20532896844819862719302461052830608965671775711098369002889100226843723304065;
    uint256 constant IC51y = 10165245834300535034995935060162142357012127635762461585340813984120842283399;
    
    uint256 constant IC52x = 21706945700397762273061470570984677242168625760414490349459981827557223393761;
    uint256 constant IC52y = 13018625219030750006251531760542205498208625774314240956959696899549810023416;
    
    uint256 constant IC53x = 19949734495316122589728542702311543846078135806716613800415036271605233348941;
    uint256 constant IC53y = 17610569332553481342822721120848436097030885514608311144321720352640822032227;
    
    uint256 constant IC54x = 15423868577682089147254397346746037852568986160806737601551331562387468734411;
    uint256 constant IC54y = 7375518587880462511927311850962084418893297203604477887361607048862711107346;
    
    uint256 constant IC55x = 12577671908654509512753921257679284932649171016080486414752763526622624937379;
    uint256 constant IC55y = 2822986953532073626384807171487787273923093456830811642298968906173084618252;
    
    uint256 constant IC56x = 7101901272264342721235744390437490009744607361279923026192561192184716770940;
    uint256 constant IC56y = 1960330795533000366229628853474316049039025107856221183882939857657751805495;
    
    uint256 constant IC57x = 7691495400094693753216268714788131116165195526618960887994162298184250615269;
    uint256 constant IC57y = 20266934251235402524075097510808143546332698370015625975778871109777745169355;
    
    uint256 constant IC58x = 15308904568004806838333292069495967804191763022342145474464916816147736254990;
    uint256 constant IC58y = 12725832748756479321212289733196376490749108660151710901111018005353112155462;
    
    uint256 constant IC59x = 15202083440469925507799278476974817171471136169349172236985101212482195929767;
    uint256 constant IC59y = 13450805176974038818560776381803544848148900879794845768978747920698467277057;
    
    uint256 constant IC60x = 11105808131601383970258936055037294705639455246096494991661486358952307565964;
    uint256 constant IC60y = 4381323687858725316139856902510988167456513753163202489496574375897393705657;
    
    uint256 constant IC61x = 8712061720494230564725748030948956762561835865570911224942084365139103338532;
    uint256 constant IC61y = 20285562077593608041077226666405665601710539151360160642396404391092949958418;
    
    uint256 constant IC62x = 9793790434502609829423745560658992632851959811916953980186746842770443206739;
    uint256 constant IC62y = 7049665340999458484091999269052279156744379198095613680285782390224484723907;
    
    uint256 constant IC63x = 4126142035587342662096948813543352742407412826025778459020396617635592493463;
    uint256 constant IC63y = 17515973803942265832645666042755095987623520928417041957879643390144752197189;
    
    uint256 constant IC64x = 19247207862201928049665157665966019429648008517374964258403393747624217085558;
    uint256 constant IC64y = 5883119913118532891547653021528280926034817697092548148689106955497551603595;
    
    uint256 constant IC65x = 8041509421060849686321537689107142871225800893472016045323498838246681453229;
    uint256 constant IC65y = 3431923506157888786210165459510810556282026588990305561706761506851510698262;
    
    uint256 constant IC66x = 19580268285267533656844592406379164013624739067439830993341391612509642621927;
    uint256 constant IC66y = 14902911267050146103685190334259509182241627230366165452249801112538718673687;
    
    uint256 constant IC67x = 15527274115915464115840466780647508348661881376611401367550382868666494632303;
    uint256 constant IC67y = 16457150041848329656504960671583325903799422628454043853964249079520392949405;
    
    uint256 constant IC68x = 21360934675735574499842804934486737587647946913478237997427557917461866800518;
    uint256 constant IC68y = 3799185647303562495398103200645762690993666519764820510890059834232915650469;
    
    uint256 constant IC69x = 21429820736360022235130570460476701866598520552579156149951166264823616821429;
    uint256 constant IC69y = 361471616885532291366819177862707657818109317339903791558184848883482018256;
    
    uint256 constant IC70x = 4028171144463242594484910650076389944546055584021258386802730822642903745154;
    uint256 constant IC70y = 14353333781585149641734409678186313452154764769422803611820129948675659195341;
    
    uint256 constant IC71x = 16167712066996997001640295311841282891533462998152861578318014485638243031653;
    uint256 constant IC71y = 4540890500480426359230206672050314265507235790009506090520239337837566320050;
    
    uint256 constant IC72x = 11923159010491824506757683051348000555951003334946594947386901785606478040661;
    uint256 constant IC72y = 2572782218313973361494279590352442403461305126205802617863303903726721978152;
    
    uint256 constant IC73x = 3796899408203311135956653735456167417545890607362679618739784778181219318165;
    uint256 constant IC73y = 363766308721047788110619408621332404986888948818292081892407097360922064560;
    
    uint256 constant IC74x = 4898407241626997455459623174269752843105586315823889518182507405465293557808;
    uint256 constant IC74y = 13252560933289697433715523346383499877463019419230616412590992686705641632815;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[74] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC64x, IC64y, calldataload(add(pubSignals, 2016)))
                
                g1_mulAccC(_pVk, IC65x, IC65y, calldataload(add(pubSignals, 2048)))
                
                g1_mulAccC(_pVk, IC66x, IC66y, calldataload(add(pubSignals, 2080)))
                
                g1_mulAccC(_pVk, IC67x, IC67y, calldataload(add(pubSignals, 2112)))
                
                g1_mulAccC(_pVk, IC68x, IC68y, calldataload(add(pubSignals, 2144)))
                
                g1_mulAccC(_pVk, IC69x, IC69y, calldataload(add(pubSignals, 2176)))
                
                g1_mulAccC(_pVk, IC70x, IC70y, calldataload(add(pubSignals, 2208)))
                
                g1_mulAccC(_pVk, IC71x, IC71y, calldataload(add(pubSignals, 2240)))
                
                g1_mulAccC(_pVk, IC72x, IC72y, calldataload(add(pubSignals, 2272)))
                
                g1_mulAccC(_pVk, IC73x, IC73y, calldataload(add(pubSignals, 2304)))
                
                g1_mulAccC(_pVk, IC74x, IC74y, calldataload(add(pubSignals, 2336)))
                

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
            
            checkField(calldataload(add(_pubSignals, 2016)))
            
            checkField(calldataload(add(_pubSignals, 2048)))
            
            checkField(calldataload(add(_pubSignals, 2080)))
            
            checkField(calldataload(add(_pubSignals, 2112)))
            
            checkField(calldataload(add(_pubSignals, 2144)))
            
            checkField(calldataload(add(_pubSignals, 2176)))
            
            checkField(calldataload(add(_pubSignals, 2208)))
            
            checkField(calldataload(add(_pubSignals, 2240)))
            
            checkField(calldataload(add(_pubSignals, 2272)))
            
            checkField(calldataload(add(_pubSignals, 2304)))
            
            checkField(calldataload(add(_pubSignals, 2336)))
            
            checkField(calldataload(add(_pubSignals, 2368)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
