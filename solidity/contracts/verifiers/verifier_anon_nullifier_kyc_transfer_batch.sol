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

contract Groth16Verifier_AnonNullifierKycTransferBatch {
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

    
    uint256 constant IC0x = 3496800276085111766459360920252504469958524511812389684851266298163659858502;
    uint256 constant IC0y = 6216551589609905894106801719301755417235717578507259487752009972338915796927;
    
    uint256 constant IC1x = 8661988731386656639607731751409005304903613203860475160401380448505946972672;
    uint256 constant IC1y = 15682959997875466384695015716956148084673943470205523728769588240042125110613;
    
    uint256 constant IC2x = 4864798593913495219097602156914521757847292797725856357899542281889363373566;
    uint256 constant IC2y = 4084769865429073749382259767285412015899610128867215604828172121410036903381;
    
    uint256 constant IC3x = 10946655636477519741938604788382668409827564834420270054014050675014473078478;
    uint256 constant IC3y = 1616997860682271358355985549855417651538642523066791944947927962789803216649;
    
    uint256 constant IC4x = 1011448921000895966715432920587909409164106738946407356419745977013600017100;
    uint256 constant IC4y = 20382624911228579560299862538332450643500325281048067429444766031682293704944;
    
    uint256 constant IC5x = 8386045826093793359722669975661324537153033814949636841951874232916562222960;
    uint256 constant IC5y = 4515895398826138328601262863648157084431239160298457990002579968280482126622;
    
    uint256 constant IC6x = 17775510622348825346005907267565761698626415815109759759642110947704172689348;
    uint256 constant IC6y = 21264965122524635236092634924884798933049002040438202234063941368081197774335;
    
    uint256 constant IC7x = 18509613344612882800637678882652958419057146422896016400638361739993867495158;
    uint256 constant IC7y = 5107174839318587356876505409076466207229927593217569772458176829144448081471;
    
    uint256 constant IC8x = 18322755110901072763621390233918055953404176213291710837241750292385365121291;
    uint256 constant IC8y = 16047812758091622264300550236748006965592948097066542731788267305037300200649;
    
    uint256 constant IC9x = 16835270827885757582755124042634170105555185161594983752011319700152313195014;
    uint256 constant IC9y = 16703279130622201731250308104336637500045237381995401665536532374408425657112;
    
    uint256 constant IC10x = 8251387063479818318139728393336208628139494913021261778623510408736091673478;
    uint256 constant IC10y = 19742721966482737966414889498334106453658260193814987396493187547300211131042;
    
    uint256 constant IC11x = 5831316748843343494875267867919405950468921750665141134752210843548685539229;
    uint256 constant IC11y = 11692939563578313099281034173397418044168478115831767431708813958509534098927;
    
    uint256 constant IC12x = 10722186316065448088343100959806799223025320302343712435083369449479710137877;
    uint256 constant IC12y = 774274791366403877394091156781196606325383531647605572149124825125810238117;
    
    uint256 constant IC13x = 11486133452828379028489802217239763303426407440238671728617170175764155710694;
    uint256 constant IC13y = 6003900274553736160313238806091885569304694403134522988606061031302444911307;
    
    uint256 constant IC14x = 3715260765329297428401150918913107043115296807145536339837060198397196274809;
    uint256 constant IC14y = 16735623818382190600811638447134146016040977030114745911831468440063312636679;
    
    uint256 constant IC15x = 18670811871541059725805020323804524069370902569394243368929397206213424688690;
    uint256 constant IC15y = 16769264775311542298243527785605914453369212289742780721161265489550983256071;
    
    uint256 constant IC16x = 10988183455705549305529595761896214530535338496725418604581242740729538000293;
    uint256 constant IC16y = 14082212261683651784317840481001723399840129524967769751811876727373626142881;
    
    uint256 constant IC17x = 889258195369707939513869571845443296692882650840832589571333894111038145433;
    uint256 constant IC17y = 3564112170029818402124539432575629956015656669828495918870382004204762950658;
    
    uint256 constant IC18x = 7535715282677386384703735827251430772829114446051544733954207247600400077856;
    uint256 constant IC18y = 20802942601537449650519807682302285546091072921127611617498652807156131075591;
    
    uint256 constant IC19x = 8583752573611542464606456994850274264397186083597196392210878915064350991312;
    uint256 constant IC19y = 16565754278205785089899588599939501521662382596760145291717585656221278544341;
    
    uint256 constant IC20x = 13518267089635417266617262691983932933326096920471722492820404514750415009376;
    uint256 constant IC20y = 15974908828081632083889990067284611932562828153925947610872800833491657952421;
    
    uint256 constant IC21x = 20281959968386523715865327116264357176586991058135276600420748141547675364367;
    uint256 constant IC21y = 2744104443145169726732451338599105355136202160246970988160127786810638340214;
    
    uint256 constant IC22x = 15677025527901315356017242476236417305776060626341596180817712145094904049893;
    uint256 constant IC22y = 14839790030446249938713606792435230907531580770441832960655508537130015659401;
    
    uint256 constant IC23x = 15163570026855422036014795147075417577530226347214651353998228598209643358022;
    uint256 constant IC23y = 6205698094575433490111635054492410501502243481701053483879821441867080373121;
    
    uint256 constant IC24x = 2715075316769639393861209030695429158910860373021593881049099713724707532861;
    uint256 constant IC24y = 327380141993319855696940894503992172742179606182885159069996889530527261611;
    
    uint256 constant IC25x = 4316701232553039140244348343021256055228413173402525302071802228051423163055;
    uint256 constant IC25y = 3479399365943528411325203891840431684732668612091246864187037012315385883122;
    
    uint256 constant IC26x = 4089620259766097445323003945252864701816180374247246715402261602986074085034;
    uint256 constant IC26y = 17726444859474088091991654727136304195495130540733141491147572324203109291154;
    
    uint256 constant IC27x = 19061936766027228748066551048591889452037905303631540696894427343049088997051;
    uint256 constant IC27y = 569999294190693210583706661016158781758765140266703342475797875386716508320;
    
    uint256 constant IC28x = 2450430552795153639492774999434954114787997859583019653792496083113146140175;
    uint256 constant IC28y = 18583035020502863452718997325977745578951282499556798143497222617696962569648;
    
    uint256 constant IC29x = 19236514458770560797412444568666854585249315892019986460858390006387965372326;
    uint256 constant IC29y = 984795654476027211784138588983332291451392316802163665450598440762882483334;
    
    uint256 constant IC30x = 10238691872303482409045248007042785884876646857294477884840697771093249110335;
    uint256 constant IC30y = 14379505274759052837145059651221763686685236863696885354092736803937658112525;
    
    uint256 constant IC31x = 9606476299755169533291311694732388401865796733856723454308015328477520798667;
    uint256 constant IC31y = 3961223876841465663642700004007518297317852036898264917742757371006132020025;
    
    uint256 constant IC32x = 21853366955716807838789436061891493570361529095600059716584435865689136174718;
    uint256 constant IC32y = 13022678060475534261542042739885059053818179182161699004935420033160002971946;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[32] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
