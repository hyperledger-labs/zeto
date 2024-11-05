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

    
    uint256 constant IC0x = 11440393942871974514866869127272798177910063098495161064380617913947836707883;
    uint256 constant IC0y = 133186548537922933703816851228186559672737402151435687458413732717456356699;
    
    uint256 constant IC1x = 21373502176400161146006095202392315245434857405673246292304981642513085314126;
    uint256 constant IC1y = 5973954329693434352436139985867871181759296344186415170634863590214156315249;
    
    uint256 constant IC2x = 12019982747471100639634052399766418050683537218547481676294176787917881186607;
    uint256 constant IC2y = 6405218792291212317907081159284014400722968772889118220663168950295447220705;
    
    uint256 constant IC3x = 21541101932056629567381357223394008276342942119132930855282215690662139162650;
    uint256 constant IC3y = 2271680116783907835750785191482937543677602522528953806278114962346139021582;
    
    uint256 constant IC4x = 846331695052133801075541266442844556008871193706530866288171629930034596396;
    uint256 constant IC4y = 4671805763816924754378540315344588906110138930562619888525186553727651894671;
    
    uint256 constant IC5x = 15862626577644729681546548720212355443270891570787917457090900376528365907086;
    uint256 constant IC5y = 9430270885582061272669262029645569297998413282783538758784652807562041710438;
    
    uint256 constant IC6x = 20364249990587186388777009860293192582601009345886932525111517332970281035952;
    uint256 constant IC6y = 1334839598218736363793400104054202408205710585818802803620178832624743447850;
    
    uint256 constant IC7x = 12417757356672597564383775211044365887294796389246614359706817666990934075472;
    uint256 constant IC7y = 11622602145382847018929095868878319532905122146499153532367406851678378002641;
    
    uint256 constant IC8x = 14699923273545238120167631232296601962479972604389646857920202246888502080052;
    uint256 constant IC8y = 14113362150999156476310073110539209986750711174991138574097387215312366569174;
    
    uint256 constant IC9x = 8439229104977825388669923085680058133619691762568298479043167614828429982095;
    uint256 constant IC9y = 18240117404538846169532854195037548821907165749996481825180835374832517741368;
    
    uint256 constant IC10x = 11470068336482550075073943174397386972643000630660996382156267717482343276882;
    uint256 constant IC10y = 20866452478089653295612124088992944102461995428176614117027783837067597969494;
    
    uint256 constant IC11x = 5791701211966382660399104629271827990912735697930109332538539212590763373881;
    uint256 constant IC11y = 153318489220773001009409735672747935918849189063837110094732063052591331798;
    
    uint256 constant IC12x = 16898606392771231052990567544051778925910589899871105246361034023158641157159;
    uint256 constant IC12y = 3631355825733666009904874214578874855423710278467279916288619855474525466184;
    
    uint256 constant IC13x = 10247329403841905396872124340913483963292585745607093613365322600357457687457;
    uint256 constant IC13y = 18057379678526830268883725029519547573327109531784984832234011504205340806389;
    
    uint256 constant IC14x = 9355678805354983609419201612177172575228638269901476278048006979878502187870;
    uint256 constant IC14y = 16692888418935032480811326079443835813838711826121682467276641845580020694985;
    
    uint256 constant IC15x = 19470575851572592678964883715648962849258649150864531049938150618719229740643;
    uint256 constant IC15y = 16087485769910776554782414147987056180184775349044797807400276313528404284475;
    
    uint256 constant IC16x = 16927358836358577381649034111095642293434944349737262725338110349295469171890;
    uint256 constant IC16y = 5633252844575746793504011224909489108395169921046386508695373017595756224798;
    
    uint256 constant IC17x = 466385751153760267057088342819394273436492253355181488147745146987443561174;
    uint256 constant IC17y = 10636681079806759477335090130399848626160046066427253831641198982014030636852;
    
    uint256 constant IC18x = 1306160653778651739731417814007205094611179956111728369166488625644167470841;
    uint256 constant IC18y = 7444879550181354110118157729417180300292135282670273926600932204849101017044;
    
    uint256 constant IC19x = 1678115445428524411417890376810656256573782434876435263457891777353135617689;
    uint256 constant IC19y = 18338814368959235131132148903471841522279798213196427195770744376229225984812;
    
    uint256 constant IC20x = 13475518625343317374653261886464125169531008269785394794386292166343992054809;
    uint256 constant IC20y = 5932940654476357527753202165699205095329934257088828727832277287208370120937;
    
    uint256 constant IC21x = 7921347123864641135079572825878900108520077374695289581231865590896941725406;
    uint256 constant IC21y = 13630426985012118038457039705336667119766200581198072395526813535328659645427;
    
    uint256 constant IC22x = 12444411055588360895738441441608818038189443178213456739056930867891670695793;
    uint256 constant IC22y = 19844505351898837377485008404126311544873570189001934549491240425304683893761;
    
    uint256 constant IC23x = 21749054833910211486879296937411559584455172477774736168887294488892823110789;
    uint256 constant IC23y = 20733838143804177645847095182210650193921032035097913695993813013494796554878;
    
    uint256 constant IC24x = 9416811339787510459121579505336239446177100930643837924054193303528446775946;
    uint256 constant IC24y = 7496529505075181120033781430526436950403023957543412141861124587382165460116;
    
    uint256 constant IC25x = 2521037654749916061705436196328419692378725242316483482537605406140966371785;
    uint256 constant IC25y = 7481355955219106431418764349901209151469635161458088173530010275965718936685;
    
    uint256 constant IC26x = 6159877667151052542275925153356898955756904311468966193307411548252975180841;
    uint256 constant IC26y = 16957951729568467905949534948317393115956705369972511767296223548702535081265;
    
    uint256 constant IC27x = 15895763439275966699350516503752383386910876897737925080464955955128432705111;
    uint256 constant IC27y = 19175140840659322458007940683412165219686476779035525370589132195070063770866;
    
    uint256 constant IC28x = 12781043689434879144913554102394763693323529473062298868310352629331148459735;
    uint256 constant IC28y = 6283658702263955451222955098326287456301140412421667344161433264750419443719;
    
    uint256 constant IC29x = 2650177799351619826805750223838543610631746513548033885306673977535830512438;
    uint256 constant IC29y = 11132853976141241068020587349960899145809492234214887160916201017351325157988;
    
    uint256 constant IC30x = 18736799734640059151631443676921126568985757613276002385521759325513804802626;
    uint256 constant IC30y = 13415376103030171487081928512271085772013030109823863742751982671727582658980;
    
    uint256 constant IC31x = 21557286671905088889566402390265061739199292656885684789444524077382701944387;
    uint256 constant IC31y = 21231741331124027945182785630154125653093132422383614600901529412439218627922;
    
    uint256 constant IC32x = 12940528791904943075774630271648139819183770363825384598751929176612396816309;
    uint256 constant IC32y = 11715714066859572983732294401113791297224107355127784357906283556606876697313;
    
    uint256 constant IC33x = 15336252354396723554713307983151576076480035697833410433905456356379362289152;
    uint256 constant IC33y = 14285566909120907110744857231861482433624025779532059993332654722933225940108;
    
    uint256 constant IC34x = 5884577964744879110464156647383403939257839388735429724437551422558173872878;
    uint256 constant IC34y = 5958469892694001137576744420567992763085818335022123188788525319869299417926;
    
    uint256 constant IC35x = 12672185381524358800675435215363054959069939703263610081597439227371768295908;
    uint256 constant IC35y = 4991666983404014883734579567062205281670188976932731580697994319863342756299;
    
    uint256 constant IC36x = 12479464787655150134135032355208700460404887585786595715857516484397392313829;
    uint256 constant IC36y = 1018320791027450989526892580853893042106757239279085768037427870333029668144;
    
    uint256 constant IC37x = 1710643914829437416138882539041939546506532462061817333836637216015869647662;
    uint256 constant IC37y = 12758226704627400152672369569500323201628627877764341991772159440849241652318;
    
    uint256 constant IC38x = 20765423861987687018960117496746212962602364675866980462375997324206523750961;
    uint256 constant IC38y = 16346792775445301799414964816645507499977984096536245002791954274903053139217;
    
    uint256 constant IC39x = 769465146932722209788345881040630992027977262524965120307379443463936171679;
    uint256 constant IC39y = 21443221478907556614563646521746551171599710041754345128056788823735122681237;
    
    uint256 constant IC40x = 17934915773114640094089803521072902877108147466572877311941777900066340828562;
    uint256 constant IC40y = 2089630803626128852847674177433115291541250343192228772428174089220616008628;
    
    uint256 constant IC41x = 19069098312515111515913865066329616110413992526699008469047325420085649846405;
    uint256 constant IC41y = 21815260540752989492591652481223879022266876419689747999044678166262558790856;
    
    uint256 constant IC42x = 10809794399203216633674617798989033317170284850724966590352654005949446023921;
    uint256 constant IC42y = 8433609511982756020036046061867269263905241468097428240413170301892914960646;
    
    uint256 constant IC43x = 3652884951545472315780642784058908506025705241661109657711983058977740335518;
    uint256 constant IC43y = 16718547234608374755814461499223334522439521447991730611938964364530421750378;
    
    uint256 constant IC44x = 20399377428052555283592449607860423606769498358874252853329147197150739355907;
    uint256 constant IC44y = 16556374609250855778134596484213736855732191729177044585168560291812583756028;
    
    uint256 constant IC45x = 10708822128089989461610654435805634465615772424453005428200827077707345279891;
    uint256 constant IC45y = 8986910629375303890530817347320539597845661305178427869950691804248585867467;
    
    uint256 constant IC46x = 13749491805056691340349871073294477065213263357473867868125395711462162176129;
    uint256 constant IC46y = 1250535023271277639774246389869019299402949021642971080092585731781818172935;
    
    uint256 constant IC47x = 15639821013754284785460152597463271114837680345843427655802176975135241556176;
    uint256 constant IC47y = 7497411966234756803281351283197275455100909191193475471732361426882334132439;
    
    uint256 constant IC48x = 5247394744580383162319803883596549790767893837459941811796348428134340303425;
    uint256 constant IC48y = 20494387416613468526541358070169052310945632991675833441592528596578971425367;
    
    uint256 constant IC49x = 15954385881062613030007725744410323696099356779349117616497265076137016023734;
    uint256 constant IC49y = 12667344345066946692620059164357275763295684555947058798684386937405656819211;
    
    uint256 constant IC50x = 18078434043538031119022650317809314372940509163736609186849977280253768224194;
    uint256 constant IC50y = 3419971708207376779851386872531770594433226603112927364864376900733842905468;
    
    uint256 constant IC51x = 3759145415901156720437452986698072719112520310450557525399263838265242391827;
    uint256 constant IC51y = 6716939491258801222935133951532004171520559705891812293321372970851631796026;
    
    uint256 constant IC52x = 7364733738232452043160914112067800746593905436783431339219885422871006017641;
    uint256 constant IC52y = 5945701054852610437357795975805602116200656742603744603199271067047054100168;
    
    uint256 constant IC53x = 10161087304339651665742850572903580167606445505587584113126003091680506085981;
    uint256 constant IC53y = 3958986789563191997480973479407045271476123589250947494184240050711031105990;
    
    uint256 constant IC54x = 2726263682344228078348252481826417366560238713527921895614086992257330158204;
    uint256 constant IC54y = 997958397940019682815220974948716632066175974786808238577314576661045691960;
    
    uint256 constant IC55x = 1926242511687472557058300862839601536946432099790245016559074402316241678910;
    uint256 constant IC55y = 3319640688574460002522461016350749706380290607848043153947150634655864667434;
    
    uint256 constant IC56x = 12522272332000206141418060323853365191717642829460663005642057685687066553527;
    uint256 constant IC56y = 20568028321555624779555553726028836003373111729620748325061447026069428351834;
    
    uint256 constant IC57x = 10283706090108198136650704995011662511751290065821609863052995267043952980988;
    uint256 constant IC57y = 11632752132030441524555083263261623579731945265325046704298411976535588246882;
    
    uint256 constant IC58x = 11750786146065218417141362677202420092073967551645504253517612595274898423357;
    uint256 constant IC58y = 10851933161697204467076247982660120664809926930484917818774157530383622504538;
    
    uint256 constant IC59x = 19025380440651297123274829482620960985789531251016373554555913573051339816420;
    uint256 constant IC59y = 9133147662047865797501214799481608195872979317304905168224982706262707448693;
    
    uint256 constant IC60x = 5782393520656463621751414457114290106735644642923732449998918283389037264095;
    uint256 constant IC60y = 13620477319273803945249692179490042363671331459259852140866717956107673841753;
    
    uint256 constant IC61x = 5607738112777235562463163473215785586728084839420819714984382481115129089347;
    uint256 constant IC61y = 21512738346967511486013351746949884469437059175937970792978006018659680461155;
    
    uint256 constant IC62x = 20464354001101222902864737492093113414317555530837891882792309935662575912331;
    uint256 constant IC62y = 10326757472243180920583015806255654663741889238757369760315492840164334092336;
    
    uint256 constant IC63x = 15709348470066437218193520187942944684132450447428583692826298750685054700181;
    uint256 constant IC63y = 3213872110886145875919374026933926950123433489246192124387780111602051935165;
    
 
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
