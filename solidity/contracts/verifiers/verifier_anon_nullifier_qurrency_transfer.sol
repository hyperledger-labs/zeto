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

contract Groth16Verifier_AnonNullifierQurrencyTransfer {
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

    
    uint256 constant IC0x = 16887669832464593236082296911748552893861407734681287180647210138606612512483;
    uint256 constant IC0y = 18608291832031683502750450371191739667778090011718098077418116061465596699229;
    
    uint256 constant IC1x = 15891696770277415676973669218295675208878327352890764875858609181080862929131;
    uint256 constant IC1y = 3182910042078889448371124485401857037512974142753223919068700383232250378145;
    
    uint256 constant IC2x = 2352959194227982789446795352838781107416978212290258055246395602103788258930;
    uint256 constant IC2y = 9009233291026759584434035973453629352623988072903561644598056030809858439349;
    
    uint256 constant IC3x = 19288333594648179714686502683279448485176828724221781583700960384882741516529;
    uint256 constant IC3y = 15160484411252524885232159806736831207327469057594238900213008561181888869804;
    
    uint256 constant IC4x = 6496358497151674561747337330833938741373744959692343517917820239486673047551;
    uint256 constant IC4y = 13001806677394160057987801893999317034540421603204659599983655307605254061247;
    
    uint256 constant IC5x = 17711988254917392251955794739598705672890170324331651028230239781300700936772;
    uint256 constant IC5y = 14663928598094975599760862283532713716050773190783049523301125427297743537005;
    
    uint256 constant IC6x = 19473982883214943050007258940944623428851693879144296356334441145951936012939;
    uint256 constant IC6y = 18188452740634322384235557240577099791446201640969532412698369452583563924417;
    
    uint256 constant IC7x = 5884405549631487724259525340989491479646782858359220345656639356725480045583;
    uint256 constant IC7y = 16144481575866636462606526634459465832317996379813433280422533047995654567639;
    
    uint256 constant IC8x = 20604374033404150954454246821510871898628479794914318358185034097274526086733;
    uint256 constant IC8y = 14750562086942196013817755387724052670978826991819655367022638353405300827637;
    
    uint256 constant IC9x = 1374702780922537662456254754801272175651043102697010613990986241651520342687;
    uint256 constant IC9y = 15659599858245842661758324791573351684239753758316510259205154455043297910720;
    
    uint256 constant IC10x = 782756157514976697075382918665178161385688029979209326909683471273115716299;
    uint256 constant IC10y = 20495196239386443774432358640069234995043274295642365866406581762084395436433;
    
    uint256 constant IC11x = 5999457973297366189486950066102853338894472720259822287510437641432321583329;
    uint256 constant IC11y = 19700595120891597080897954443630928784582698160577928021697211591770338158133;
    
    uint256 constant IC12x = 10559594771184999829669438094633317462094334053476697324442703649294983045602;
    uint256 constant IC12y = 14162233274527957435212433469327190321564019773184816208351886826997639855701;
    
    uint256 constant IC13x = 16046049367158232183599014708569410616701028413447726523041008738919125935475;
    uint256 constant IC13y = 13345658271627808789595193638461260308668769971232701071985198095860356605749;
    
    uint256 constant IC14x = 139166418043510886860168585186521749113400966833757538208669378357017609582;
    uint256 constant IC14y = 11358041954386767389547201608807245743605650184345643061806747583494312758921;
    
    uint256 constant IC15x = 8883655349644432492050901110061217386564804899260202266848546458392540799880;
    uint256 constant IC15y = 5338205061941569164899870936739316102020945298482321320932694106593172622616;
    
    uint256 constant IC16x = 11027498932428522471046726552054448678057202376411341172468849391182244435489;
    uint256 constant IC16y = 12051382259879517285520411221588771634814320275858034717306750989060591449523;
    
    uint256 constant IC17x = 14144527500881229555453656495317582191063485985945776841001703962886242927168;
    uint256 constant IC17y = 18830425888601510976578247743192249648214048500304367195679723428290945586664;
    
    uint256 constant IC18x = 8907618301587231697327108389387170234940427304456014059461433938376383368840;
    uint256 constant IC18y = 15927757235785375604681323507056480211408285750259769351775602931505704303067;
    
    uint256 constant IC19x = 1145754685970988071178235794152256043093308025493525600394927029027127533414;
    uint256 constant IC19y = 19665658604513552309195162181425460137641464381105914774061924819562678377718;
    
    uint256 constant IC20x = 17928695252772970127251625549861408149627692728589503214527224691636174880617;
    uint256 constant IC20y = 17645796273781860957426473839957368475261336198410524561171430041415312271692;
    
    uint256 constant IC21x = 17836872467137890166791425018365678473394193677112324757192530952947214494559;
    uint256 constant IC21y = 19797868097388807498147816980078975019746291958423976407470274092455278413720;
    
    uint256 constant IC22x = 20146285178360971635789031394155361535647699331704399176967815678045294296341;
    uint256 constant IC22y = 1428372927632169139379434757866356693153488017707018616934665547563757202491;
    
    uint256 constant IC23x = 14465378596066373916779819363892771413371969025718725566819541754255884995806;
    uint256 constant IC23y = 11137105947395363210649152512797526481846181648325556835850202186707899092996;
    
    uint256 constant IC24x = 4301965617371777488840222186778095289408088882494584564900151705565405222523;
    uint256 constant IC24y = 6132825851972235408911947805367173734830312116996433820156279432558019025138;
    
    uint256 constant IC25x = 18554287162980602483892355924157691329834546778534338800519197588602235536337;
    uint256 constant IC25y = 1615456283231315381374340832910722752082365816773527200850661236241875366037;
    
    uint256 constant IC26x = 1008653072485299340326982876517665041357234807524837100625241290045539948197;
    uint256 constant IC26y = 6097020964546954834044655907734800772139282162280621005909947791321995567608;
    
    uint256 constant IC27x = 16103142933978500736532669758503502009355817053850471332370928145265732173437;
    uint256 constant IC27y = 15246657777687970241878574038434175650127789967720977236234699444450640437621;
    
    uint256 constant IC28x = 11462366661397020204591935019759360692886275300096115780500460093557832197956;
    uint256 constant IC28y = 14906274787189332863435213198987571025297707195664160233123129225795558929193;
    
    uint256 constant IC29x = 7270298981750138150057350968485637459441028389258488771181565752464583715117;
    uint256 constant IC29y = 6856668989292878094006081407865747913980648789224885453076432719308916519418;
    
    uint256 constant IC30x = 11681172821731598238145512627981676534744356084503659028201423476940637018304;
    uint256 constant IC30y = 15523744461174544759680865307122643190458909591078943990364124496672134582655;
    
    uint256 constant IC31x = 15554763887371990930622662926829737300882474217024338278572279606079200119144;
    uint256 constant IC31y = 17071626728408766386898403914550626666690792486358170327539827025228923762843;
    
    uint256 constant IC32x = 13893806824024371359209376538205048480581903384616805642702780389775314423814;
    uint256 constant IC32y = 9560963950167648607336748591037708354389568902043413440034762267504217217279;
    
    uint256 constant IC33x = 8345661969049249262725127912663508149664246328857272384298775558576786808393;
    uint256 constant IC33y = 9307836159640927850705298219428764930247270000963609342373406132763242599732;
    
    uint256 constant IC34x = 13684673648342697271233595927738350338029318308034333059389311010518567073793;
    uint256 constant IC34y = 20947381107868976608521702831273500624952326302789191035384913696663711392444;
    
    uint256 constant IC35x = 13619138958670975911945568827746148243879646206528626166808237418252308629292;
    uint256 constant IC35y = 13588996927702226962866282266127792899113610213264813199378446054965564199194;
    
    uint256 constant IC36x = 6167250801376812651084072477180311139998056968010804177969364066065115458508;
    uint256 constant IC36y = 13544227400459956690942354625299248039422985468883308282263162928478260218454;
    
    uint256 constant IC37x = 13361446424379031650724133221649553624958521883595237004495755769685307373042;
    uint256 constant IC37y = 16694125891698559829795414315919019687541893304106817587727053596619761099519;
    
    uint256 constant IC38x = 17818537342937814296626154714738791666978026937177999807807652292153900400589;
    uint256 constant IC38y = 13275081702486529987539616562505819643100453986859963952543443148904991175693;
    
    uint256 constant IC39x = 8554748858268810735208394172589241159191554660356374888070894336229655368802;
    uint256 constant IC39y = 4486165250097765312968355150355054375220483736452749018194235064804715471484;
    
    uint256 constant IC40x = 5264995887940519042100591560380278065218329466455415019283806796718933069320;
    uint256 constant IC40y = 19328942101283296514265749153446239982110466169707806065030689438371245444304;
    
    uint256 constant IC41x = 2161556662259494346937366320663725421312058872787844570846458586626740281197;
    uint256 constant IC41y = 12963074626983324063805481600650423520851392289217241871955702289673012875374;
    
    uint256 constant IC42x = 10324372124390973799502437124831236178561092082812831881351379320868540193547;
    uint256 constant IC42y = 15192744497439179323224497544202617539218568471650431933201025701125697264648;
    
    uint256 constant IC43x = 3015196296954271936262783841437040530474080390493392860708260489520948795774;
    uint256 constant IC43y = 52197373016097706668294966762851951764247794139184607637904577472799736812;
    
    uint256 constant IC44x = 18829975211913695918553088738500831159970130427844259996887633050780882371388;
    uint256 constant IC44y = 7638428674898902826834221026730696241624203329463884060083898626350839546876;
    
    uint256 constant IC45x = 11205020868471686992694740556553880702496123567954607786146254820723972633804;
    uint256 constant IC45y = 4949866613433638060647844440999370710358474879629696007465746586946325128996;
    
    uint256 constant IC46x = 5026492918991910566578235401542559868835758466135072846985640962128744419593;
    uint256 constant IC46y = 11185480280407528284412644979180947368053734553331090952055703704521179971144;
    
    uint256 constant IC47x = 12587551325132827862107046514771029730289498866210236665389945794510332996959;
    uint256 constant IC47y = 1800686231395838291954596810498321698385566118282703388230955148116279409756;
    
    uint256 constant IC48x = 11128939178652447170018229248030403334621215092707445424305800225008971610915;
    uint256 constant IC48y = 7896364350690882371351547638846432735918796272200484409391898866303808174182;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[48] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
