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

contract Groth16Verifier_AnonNullifierQurrencyTransferBatch {
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

    
    uint256 constant IC0x = 21617836361210630415474148451093079503089966001227323865469178057979915492882;
    uint256 constant IC0y = 5021510973691734206889512241000157929162598651328610224525819160216642651872;
    
    uint256 constant IC1x = 7801246608855726035465975218720626889336095871460344172715701624274050323503;
    uint256 constant IC1y = 5327373782657580940682864105951865892337482545935580711658302706545119863930;
    
    uint256 constant IC2x = 13122956178607244418092171489108719596863657745423423473872267828961482636583;
    uint256 constant IC2y = 11830569254276365758174012405447209894895871405069389068334959383191227791859;
    
    uint256 constant IC3x = 7704062303339218515937275080341308516495920795045125968947787147103365531313;
    uint256 constant IC3y = 18607641976421238080811126234654005768609412476894806690846359766323843297629;
    
    uint256 constant IC4x = 930829796973710599819827470493714858222046780305705082484905748694742959667;
    uint256 constant IC4y = 10889301074727363816019615333017990775864779581325791131629918088129266481625;
    
    uint256 constant IC5x = 15423837277130047056316879903254692650426350762686086775881697364872889943324;
    uint256 constant IC5y = 20199813435148654086062569744744696372689147501788283070707325054137214827661;
    
    uint256 constant IC6x = 5698306188249675798070371330137780577269544295161106600587207885692326024128;
    uint256 constant IC6y = 7859319708432328687941168840805360885436126136420282503243756449691453613828;
    
    uint256 constant IC7x = 20972978961646826986513675485208143036832727676953870546575440344709500097827;
    uint256 constant IC7y = 4957591588489037327047591581817120247097730649480854778460114010255458985451;
    
    uint256 constant IC8x = 7786535302839638778777953023318152752551196583340455721299221643715115329390;
    uint256 constant IC8y = 12982409407485801671964352410334380212945572811362587207229945495886573793300;
    
    uint256 constant IC9x = 4539542462112382192290786697403592049659657034243673389669253280325160431004;
    uint256 constant IC9y = 11006305647102941789532911208949257329490330581753390657867179733138223347585;
    
    uint256 constant IC10x = 6072263334634114195759985136220858822312979024086642571614128766933399194139;
    uint256 constant IC10y = 11625919410497078401150537500255040734728922928094863728386119472108976347161;
    
    uint256 constant IC11x = 6542929049975074597151759440527419203532944874298552549270735248730377311222;
    uint256 constant IC11y = 9023328504901971287890112697495160290352791933414322917991343309464381835833;
    
    uint256 constant IC12x = 13503355356133068354546218912810802142643968366695646968108176061970408314222;
    uint256 constant IC12y = 12216803023711452867880225581532902419097419460634480136154268155036257138229;
    
    uint256 constant IC13x = 2853295695642838435814295212634032755927110407673847035340351352998536883482;
    uint256 constant IC13y = 5389082808632057009074070058894156970656532599286702462968515656044785042942;
    
    uint256 constant IC14x = 13937741735178745330648158577969281493944081342267331306576396414550366775564;
    uint256 constant IC14y = 18261282057273104291799901739513374005853096750986752073551757142559238505859;
    
    uint256 constant IC15x = 6002183865514041437729644400093510699711029502650748786670859808016078364910;
    uint256 constant IC15y = 1899690905694523061806893114596318523538993458009611494639973070719247242488;
    
    uint256 constant IC16x = 1382420435577755015597949941199567210209968844578376272571709936168053259906;
    uint256 constant IC16y = 3452983917153203627766595208066272419525607477526469739700781536280266508719;
    
    uint256 constant IC17x = 8181678972675168147523093715001552719391015665678407870046394322029421056971;
    uint256 constant IC17y = 3411732090316377390034424458547894865684889620782558845573167113841609079594;
    
    uint256 constant IC18x = 2802541163495938928281219465771915219178129266929771780019978743260752685626;
    uint256 constant IC18y = 20302441039616954139960522337541538821183807948197134682761981640167091087418;
    
    uint256 constant IC19x = 961763374721540574917916463353818224524759011928996525987274996826244923477;
    uint256 constant IC19y = 14781236469540032151282805209548874090987085038856378616195099980944390698840;
    
    uint256 constant IC20x = 2911453945871274056996370100229071412906550714179220244737958242267384372436;
    uint256 constant IC20y = 14043176016015786034890909915755763829268615797024807167094784727305845147091;
    
    uint256 constant IC21x = 19317454545997741472751431947834587129417136263170835726472083035994915089997;
    uint256 constant IC21y = 3202682393237800497780387062646471196719547525859187909997519052402602676223;
    
    uint256 constant IC22x = 11312744548290152058540733422591784184279948970914622392114573222345179250289;
    uint256 constant IC22y = 3245048772787278532205560710905634475192912903356769282323499164697555505021;
    
    uint256 constant IC23x = 5859607381368716501793994017551280080337807553991496243803354797834033424757;
    uint256 constant IC23y = 5095628910529132503897238380189066998871191900386061714638236896052668961119;
    
    uint256 constant IC24x = 8670086027982387014170847678177170748365404233641166161560386337552548694161;
    uint256 constant IC24y = 13706959829436097830728952646734964584408275828957101754651868474537125960687;
    
    uint256 constant IC25x = 11274717990448672423699637116128937049774886884891705154551233593870545596370;
    uint256 constant IC25y = 20607766023096949164546646203257428039011948308551110813945135644378897741146;
    
    uint256 constant IC26x = 1060780189393926956779962542697498583154481664515767463402898897459340587132;
    uint256 constant IC26y = 12334998139452484575437041812035349658574723720250333070525130525136307479095;
    
    uint256 constant IC27x = 3296015586406463662305804411891838053243270892195157850448399011790658967870;
    uint256 constant IC27y = 1850291291290068708312873900417352615678859115679307800475060415464149336482;
    
    uint256 constant IC28x = 20015542107213384291058618473469271194453323828293898995140685852022451606541;
    uint256 constant IC28y = 21328371139791071933766165090668164520115801093407850196379890036266044427688;
    
    uint256 constant IC29x = 14913179948310492147858277839631068819679804572611623336443928894202444057144;
    uint256 constant IC29y = 9744813193360881193988747208568528925931204346962308226864600344701217099130;
    
    uint256 constant IC30x = 8853810709214344359756817008462977718552764839304188021434053309734080247390;
    uint256 constant IC30y = 2240646454290337956783001835410421497408551804830919820031500592336494128819;
    
    uint256 constant IC31x = 6643797158363707786095646475440240616448843121888210669748926691478082115878;
    uint256 constant IC31y = 1062770198003375783202878961424028924286997676610697884785068019369214154021;
    
    uint256 constant IC32x = 18725820284549966064276937778018298800687327084011765207343759156423604194502;
    uint256 constant IC32y = 7159947911812308759827635457414456185330030089713983997840570540080166229324;
    
    uint256 constant IC33x = 20387987688687240261665455180697020641470446213793199380494325054223038171134;
    uint256 constant IC33y = 3769068517756142697311228562634232514111184926487421685157030105934119568895;
    
    uint256 constant IC34x = 3794140179400193901371369984383479949503123725227176663393365384630189501344;
    uint256 constant IC34y = 17305055831903886388826089991367718771420877253657276222068282639257765794274;
    
    uint256 constant IC35x = 11496354272458228343784654302891866420898780249947383594247197845664550452568;
    uint256 constant IC35y = 10115291755953685603447206457120860499534320863109619524789067908958044822629;
    
    uint256 constant IC36x = 21376643050341225078356369165684415699874249805498925695983967475279328656902;
    uint256 constant IC36y = 12242495664532094816146719935785249683548987784536164463535011119606839594969;
    
    uint256 constant IC37x = 19800413665203833692115954305783361228388757237520939093079315450377462497538;
    uint256 constant IC37y = 7510195639774505867413551373200138392779923957176923557324668032519249159992;
    
    uint256 constant IC38x = 1817515322161709414379252851549954676389771190022759273667195046256718537529;
    uint256 constant IC38y = 5067332016103720184549002635208483143923451883682302730425488683492543835548;
    
    uint256 constant IC39x = 6740450446286701439805106445650933366590258606186736454201129432682442011514;
    uint256 constant IC39y = 19442182377552121485723121053417672850648517809035563192535468801314305951844;
    
    uint256 constant IC40x = 8413838916486814762180778740958200564569574737196429976044618056272554000250;
    uint256 constant IC40y = 21474117557483826806210840836262750493265400321604395411743101181951591692385;
    
    uint256 constant IC41x = 16043246124714985229989105163642096546076144313851796648674624303622426760509;
    uint256 constant IC41y = 8158802332537965546644705313285566513644775718984101953524279642884776797184;
    
    uint256 constant IC42x = 18664643946202448473327577152142282023125273219139199353510137516711278263266;
    uint256 constant IC42y = 17520724800070770252419636797723434074688250560335145152924578888851074397335;
    
    uint256 constant IC43x = 13695411453712166249302349245072969228013255831872953029400004938329232253745;
    uint256 constant IC43y = 10876576866528033920023121632976569196791370827746329173598003059436229244293;
    
    uint256 constant IC44x = 21396968367686510854726409319896808885746383643686496948350169982650507619454;
    uint256 constant IC44y = 9766008229175470692782324387166234736216539397539455563690029340456403514255;
    
    uint256 constant IC45x = 5127883959726336634049135964035657809399626584663648305265777189757213090751;
    uint256 constant IC45y = 4613496364134814823749588391731064200508814797463268024363141033867689253218;
    
    uint256 constant IC46x = 5287527219856665686516874258430202072049731454244398173268360327886303861892;
    uint256 constant IC46y = 990936685571836250145262747442455713636766092561915399485313149775297828720;
    
    uint256 constant IC47x = 18329611866836689165063596309673684883681312956042361099263723924719853727222;
    uint256 constant IC47y = 4096040524625647704065324365249659508730873696744692091278204301035378116796;
    
    uint256 constant IC48x = 92726379312790958980903139296394635561171052509163917970934399953107404193;
    uint256 constant IC48y = 10820716174510765329155221129509795849064604483728142715606284690969617421971;
    
    uint256 constant IC49x = 14862755215445921860782816084621893778001941555601702635522143987657405972056;
    uint256 constant IC49y = 477736735122561532951198811117220250940653163052033258941504959111930591773;
    
    uint256 constant IC50x = 8361287983541807388501865916547390321273479099354723752775640022475921034137;
    uint256 constant IC50y = 1811933807886416188145548889798521074241794283900833219476264487331513770697;
    
    uint256 constant IC51x = 10318400245935150262068345424742030232120396067602415184937783889803303293678;
    uint256 constant IC51y = 2287132079952315379631416290500578040334149613556951154390740533774496678188;
    
    uint256 constant IC52x = 17975688668173489535430607768040342204221979866821200729115574520989730264012;
    uint256 constant IC52y = 6365442539084956017309024562456747195302868368656271074211247158980741930945;
    
    uint256 constant IC53x = 5729063797299025159929561855079146956358686643026637070133835424377696837988;
    uint256 constant IC53y = 2749065923175276744692645268470094247930417320239981827366848974149982448851;
    
    uint256 constant IC54x = 692016039827805504108877043114273286814381676247359087005142619013121224795;
    uint256 constant IC54y = 3651475582936900663645099193622953219152216591137241858176905338376946331270;
    
    uint256 constant IC55x = 15200729701278180681375390705968218713123936281175026654740747565321602706468;
    uint256 constant IC55y = 14659476316347167199357646390460046841154389568130434184090022937968797975135;
    
    uint256 constant IC56x = 1528403782783550177686331927597164207631608320983120278872882664483608742445;
    uint256 constant IC56y = 12750489640933248420099902023883106778153496672610894038947612121347214070976;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[56] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
