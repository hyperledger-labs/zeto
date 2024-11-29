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

    
    uint256 constant IC0x = 10857768194358538314597152045783934155334107736918368597696105768676212161377;
    uint256 constant IC0y = 1551548171949368970925346068541575651000718431760521670490549085538687580360;
    
    uint256 constant IC1x = 14588657582801639408937279843859231734880127737113089109447558940418853614779;
    uint256 constant IC1y = 14270623203395264219426702964443203036050040299992199641698592426332349619398;
    
    uint256 constant IC2x = 13135368820556110030460013304378046508535906620084175730907419358915557603829;
    uint256 constant IC2y = 10112779695325998864588748108456082491374975818516659485960543973729520798853;
    
    uint256 constant IC3x = 19797205441434515503986304133552067429488642533210813091677813273868948412520;
    uint256 constant IC3y = 3668027752620361087268658844895342798986261333705883847303486025263132511301;
    
    uint256 constant IC4x = 21650017326146781414301224076216321262138091509402450867783016337102877083321;
    uint256 constant IC4y = 8899356409675534961567207862945674519692663785942434954291358650301375585303;
    
    uint256 constant IC5x = 3652696515059300354063305269323201634257733026059378405626239779412185486961;
    uint256 constant IC5y = 2797593968101997284996630534131979226227593880936820735371318427444796682785;
    
    uint256 constant IC6x = 4623401628587947458139760485392513940092100820765002768337933595735657837833;
    uint256 constant IC6y = 16915253145147865830493096188334466347397413059805656346869036690463147154550;
    
    uint256 constant IC7x = 12827823753552334302468725162427095261755116012708002987548340386275677726085;
    uint256 constant IC7y = 11226221182181486224747039503561912896098503169458364652548743214848374550499;
    
    uint256 constant IC8x = 20898559226326288889681623130919692456738317923548537960901153367615019268068;
    uint256 constant IC8y = 9070428335740018739303508108600208831132580605773750965820052322977639251942;
    
    uint256 constant IC9x = 8050097890914828889023932208013143535158869752052709859342955716385596549091;
    uint256 constant IC9y = 8395274521796654408400797569281540296411653812274481691980427197767442464318;
    
    uint256 constant IC10x = 13922997793745763139199091435552194624924338984276118041923137165159414489617;
    uint256 constant IC10y = 17190760584181366214482348917958886830342960073788461163240752374739039367517;
    
    uint256 constant IC11x = 18573754346782716206331566335772815584107457268594228676417638475501883398507;
    uint256 constant IC11y = 1276355044880646498395596779226345053506691615508461180965615150342596093068;
    
    uint256 constant IC12x = 2673539901155835498016297649459370405043711545721709136179600384236599195441;
    uint256 constant IC12y = 7435538874647432820547059117218831049516194963447372699909663787606234244210;
    
    uint256 constant IC13x = 7082087086596593606152406967047300386957049695099683464929745927413924013410;
    uint256 constant IC13y = 17313354662137902697255717796862264594146831120263509969356399881355284453245;
    
    uint256 constant IC14x = 9623241897418550147311653622048916771059084716645080539170198888417905276790;
    uint256 constant IC14y = 6797487823008499289482673886125102026103721769980091111118342554070587284088;
    
    uint256 constant IC15x = 8479487671543071115911363252047909495674631323589272460154209800083349869257;
    uint256 constant IC15y = 3612450141982960000430513805106849867756778088060194804718707745310286896961;
    
    uint256 constant IC16x = 6821902694575917726729513891819547198582660125414204630215019272992397765102;
    uint256 constant IC16y = 5712334086296308915849533840724578183836005055892623925736836078857306527169;
    
    uint256 constant IC17x = 20826828608964023659231985349704436132063025732865231636933188732724229411855;
    uint256 constant IC17y = 17839122737466360433763412953014067139047648522719765671392834780267424003504;
    
    uint256 constant IC18x = 12026046725093986521936681237367505500667270440561607456913754947526555344433;
    uint256 constant IC18y = 11134702436012104753714718437244204696034069597893357529274808560586487041683;
    
    uint256 constant IC19x = 4574280582890764783558975466068406949012517836616841998486334632675529966967;
    uint256 constant IC19y = 15846592310503827291280402888069123046276816810230296947693855874210634897291;
    
    uint256 constant IC20x = 552068498342887768812099869866536959489327984824118802930850366451374910761;
    uint256 constant IC20y = 12129711921583486092060444306009295536785476561521077885641863153904968550057;
    
    uint256 constant IC21x = 35176914906762006216694931727792728048628009777033065069148278568613590699;
    uint256 constant IC21y = 18058778029527063862776255317455122603612362893636939924117082347476024248811;
    
    uint256 constant IC22x = 16196397870560278701563331844896598282045038093084429632905028254807690392187;
    uint256 constant IC22y = 21657460375281031799499817367875046770454748835682409424465614212808894469745;
    
    uint256 constant IC23x = 13646067610627278801288663785392091700343280238288674876662200573900835215907;
    uint256 constant IC23y = 1881671896769581884207942674093567432802826560154982588372887460508857893515;
    
    uint256 constant IC24x = 5614009327966828687083870199045704608356331042583753955359206092835397597027;
    uint256 constant IC24y = 15372892361541144090465249992591722178863954946071772938944180664654818828543;
    
    uint256 constant IC25x = 1498929179339859981887512998084588849124227068666268013099808455877621963803;
    uint256 constant IC25y = 7910331318425789254048095716253514723806783780379575570917432233706022188723;
    
    uint256 constant IC26x = 217247954099122575458637857462854752748498952701241258357496332369230539160;
    uint256 constant IC26y = 14058807406880304551223000306982972305142998725126948868850812104243479321324;
    
    uint256 constant IC27x = 430355509801341810133435178938583521244278906564175006723457834948692078040;
    uint256 constant IC27y = 18749893180686672959770986175122378529608535349191403734529092834350171038470;
    
    uint256 constant IC28x = 20785267342760452754508386421043572085700759236828338637645586954138110337447;
    uint256 constant IC28y = 17232279810560518722565445717689236704547081191951847271658306446375995721765;
    
    uint256 constant IC29x = 14828539470541775206907007647640991192374577253146751470945413595997758766438;
    uint256 constant IC29y = 20636266116512194880537893502304745011905315899016958036003341230027114696328;
    
    uint256 constant IC30x = 6362433393251530635726976347941818083881377807565015744753393676431197377728;
    uint256 constant IC30y = 17290317586594588071616002431475986595423204832542336389505352030052018438973;
    
    uint256 constant IC31x = 12031451174133590769007305909501328912833754463491657014430525810498287873101;
    uint256 constant IC31y = 9671194948697245862875430655803499459356273204263654693271482110365056491506;
    
    uint256 constant IC32x = 16021565867372018867507220019489876974441461100321703931347681941849592519477;
    uint256 constant IC32y = 11736561699016988991253310519182109984518318839358799406257393145762572723826;
    
    uint256 constant IC33x = 8200654606945508236816804702951512164840224741324026288118071234406945136731;
    uint256 constant IC33y = 1985033951745928578429658688753901785557359647359090081553586066550690860180;
    
    uint256 constant IC34x = 1640774704000911509119308004239006555149330558130731176218730309685179306947;
    uint256 constant IC34y = 9295140487943942057633431978771524530551049498124720002254359354125763405455;
    
    uint256 constant IC35x = 17093734553773960402388466535220773941100757402335509298424866339239222145193;
    uint256 constant IC35y = 3059128605117733304330480104065751810591575836619067951667044079660323911649;
    
    uint256 constant IC36x = 18264102007239643202358631369090727433461217483169515568065273107416880604399;
    uint256 constant IC36y = 12143290151506783504782097020942989389269794589152906534195654995143102193270;
    
    uint256 constant IC37x = 8428721104338932910144867986251826915414990412932978591034039042589214736930;
    uint256 constant IC37y = 8855417831368285984534171368864290514645275716953702202644983517435735474062;
    
    uint256 constant IC38x = 11932843103499370774214761436679587076111275171951602594808492814845035422933;
    uint256 constant IC38y = 691857578701180269144433604942607236184389145123046325827801577397921814828;
    
    uint256 constant IC39x = 18313922732421399366802902051074755744274071755751867844450868661465138174030;
    uint256 constant IC39y = 20657589528611086334891836595390513437994430409102519679963972569081532760535;
    
    uint256 constant IC40x = 5737591812836908688455167253789575767302444278194066173184070180744214280194;
    uint256 constant IC40y = 18609635643670896696549784215672499025901018147627235066095455825418142825805;
    
    uint256 constant IC41x = 20278278333579053464183574983237084138303103723212351493753958889049485376781;
    uint256 constant IC41y = 17782657638359447051647592853506973349436993753299894190056310276416878165277;
    
    uint256 constant IC42x = 8367059665181079186528582197123102588689602937981823625326270094149451536517;
    uint256 constant IC42y = 13533135439018576382410911103119438381317655350188498259514354938167828351698;
    
    uint256 constant IC43x = 10710324277604133223652870346494841115766125505412819627873931900562308648127;
    uint256 constant IC43y = 835443959522164685535884730877434707142419429390233232546806052213058906537;
    
    uint256 constant IC44x = 10190313297374595085128899183242823870538844395173957213930013273857126190157;
    uint256 constant IC44y = 9590027764386155384343137359812160039270984799297083253615662211992466067377;
    
    uint256 constant IC45x = 5127701003800509362092012987313242991181389443752275914963019881007076681969;
    uint256 constant IC45y = 21106373523489636465875661704934704450713452883809222214575535712213772691988;
    
    uint256 constant IC46x = 21251844251739602049905559999440001661933522877836787511459551029762795553768;
    uint256 constant IC46y = 4461852991203369177281856775388032474308376098547954352881757483707243960492;
    
    uint256 constant IC47x = 11112510306315834925133583455293546665790029576877121304743879820849112239574;
    uint256 constant IC47y = 11385073960475161414263547617493580482987974358109056930913742796656451434113;
    
    uint256 constant IC48x = 14085383499391738104124103009192017386763342402227477952765942319452177549841;
    uint256 constant IC48y = 21767397946694622118459525312393256593264361917242986164985821123942842708682;
    
    uint256 constant IC49x = 4594697636626883683026684788149112839173818572790425888690620436487192708104;
    uint256 constant IC49y = 15318942332787673498467322528948175113023800541832714852865266489463146211133;
    
    uint256 constant IC50x = 12723642669487993809757271947593998575989448450414103364438128358594324043333;
    uint256 constant IC50y = 14554518787962701054328592062886716589952687831488816105655759240233901302870;
    
    uint256 constant IC51x = 85133179060454883037313071175049700673863144128662372957803647223282502560;
    uint256 constant IC51y = 7871257133812178163028061310977450954057825614043212613572384171597345881128;
    
    uint256 constant IC52x = 1342657553906280138243319647706200196355957216637027173395288566450412119894;
    uint256 constant IC52y = 14674124676602567534949781813257913237191167030310725044592635024301338017658;
    
    uint256 constant IC53x = 11861281655297301548410648207716081773199641162211247643314595471354164682905;
    uint256 constant IC53y = 10196389138883482122944241909716121500057498190147552712869019860068933027273;
    
    uint256 constant IC54x = 20200891942962698605638327267502185999986230571031250955158609431588859667173;
    uint256 constant IC54y = 15153304292411539359389306889752308608688351646100972117483073029010234843666;
    
    uint256 constant IC55x = 3590883669335716276950248120485084695435950245197150246643530675943031513483;
    uint256 constant IC55y = 16672092824828957614577382062931587381317729597881385785055550039445041027146;
    
    uint256 constant IC56x = 14219750280862389153715985369985099860318471642803942214385552911107098971211;
    uint256 constant IC56y = 13179858453644073899197689284464507638874638448373864161818477257995991484531;
    
    uint256 constant IC57x = 2701209449960840613693710200811849157832331602807774105695767757189295451757;
    uint256 constant IC57y = 16563524509859497820218951279159349182350725682127037935404341768101963438434;
    
    uint256 constant IC58x = 3414175684985968972672214275255792448199365968815072733136917287617864542852;
    uint256 constant IC58y = 18622645504279859981648376664566050322654602232963522917682794185971463055131;
    
    uint256 constant IC59x = 5673293766067799409374422371805460625346446472327627513935712864885777225287;
    uint256 constant IC59y = 21411284026213166471174879361745290776967547374405635102315577625862119814871;
    
    uint256 constant IC60x = 21670762707797115339505991245287266324440211832738175059503746008042627820556;
    uint256 constant IC60y = 10738782034331094544003210285087846694198171390500938499428724984620267862854;
    
    uint256 constant IC61x = 16953045628748754354885408433844807041994643381352716897698784182376689759459;
    uint256 constant IC61y = 6127896289376683070914145422924841131147483845624765996364406481040321551725;
    
    uint256 constant IC62x = 15246494027576980489494412837826402114800667628340474578756376600731624107218;
    uint256 constant IC62y = 255405935613365874457852565358726414769491858464880299078895428295575114706;
    
    uint256 constant IC63x = 18012406120443181819805009355966754224551722021941974548526420228517140194891;
    uint256 constant IC63y = 16799708569974408624964150779541516312120665649287169320738241105678445380323;
    
    uint256 constant IC64x = 21647434913457732586563647273051144915750412334997941554199119957585605712374;
    uint256 constant IC64y = 5646169842102849206670097642242057986777917333159187763781591815797050803986;
    
    uint256 constant IC65x = 522924794732206051621564424019162190357895804856558491692190006824849894426;
    uint256 constant IC65y = 3050433128259487878626059638882986843232307377271585710516901209069139899018;
    
    uint256 constant IC66x = 16537849522084305379050798390072027678664200652064613568035599455541956265245;
    uint256 constant IC66y = 6662048905339906711492763641949270191885435595368572784997081617988378825137;
    
    uint256 constant IC67x = 6178822760969956352675514899865740283160492055729766023642038991611137093796;
    uint256 constant IC67y = 15134676395109059167957229544083854212732194608756055532042109219146005578213;
    
    uint256 constant IC68x = 9110260865396366363122826268971881047920724953450147780963448141385604828;
    uint256 constant IC68y = 12242673337744675911914032061064487645223433319566451083780762770560625965732;
    
    uint256 constant IC69x = 6631924558989196434821622222482564144367811724815895079161517254880811719547;
    uint256 constant IC69y = 9846034906619316468424599028265876490291826573857225451304784074937609895380;
    
    uint256 constant IC70x = 2325932629982250537434955175422325230158465669867162375580038042617489574870;
    uint256 constant IC70y = 5147874583828750003443598102304571026663112923115364272095932612097636286923;
    
    uint256 constant IC71x = 20149789673939601918295184825023111621280901637012365100685193426193505987152;
    uint256 constant IC71y = 11754671591628066809903387963581104132832400142532711295607090645707718260695;
    
    uint256 constant IC72x = 18964264984251050336799823200157838869346898911672597187477382541387416468035;
    uint256 constant IC72y = 4083234469521201312249283379110780033129541751761913471439722345097281107410;
    
    uint256 constant IC73x = 19949847240940917978757815435926998034234863215803788565747379602512769787073;
    uint256 constant IC73y = 11206294668471770878404216340274277172266260874989200995267481701420802793360;
    
    uint256 constant IC74x = 1011805970818307018195611211972942213948415886755698647509050510691230819769;
    uint256 constant IC74y = 9621908650002304930897257804313486737271284104788733442484421825395527604389;
    
 
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
