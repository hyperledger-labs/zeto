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

contract Verifier_AnonNullifierKycTransferBatch {
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

    
    uint256 constant IC0x = 17375343236355586900363003481381886093300006996006806473017955684130636044905;
    uint256 constant IC0y = 11003324361223379464986796418707074154554678286422238743199135521713971155487;
    
    uint256 constant IC1x = 21076065874387408955749363814963327992219593944063244350061204866636380749992;
    uint256 constant IC1y = 20646643302684151913668580429285666875687315970342069471956892563955860016249;
    
    uint256 constant IC2x = 2958501755834051344816149494633433605057250355637838774128743357938468168891;
    uint256 constant IC2y = 8373884230703479054037811456656996277978981860411027940914890716463959068114;
    
    uint256 constant IC3x = 16612416094118692612130791913911978104910239808577943728147245533120772331225;
    uint256 constant IC3y = 18726655896705799908440766632757800203882526432127975514749600676994511417202;
    
    uint256 constant IC4x = 2432100211257357988581354829166142795755532072226084853642929561538566380918;
    uint256 constant IC4y = 20847113256178179348453925120307882808266518685893934643297357619250964926197;
    
    uint256 constant IC5x = 10214672001645059978707326862849820351888805429140033841904185924515658537441;
    uint256 constant IC5y = 14851987769586588277781966522264066506544418998470276288805087273676556024257;
    
    uint256 constant IC6x = 209014246578763005738194351176474817585942604778220935309780414836512865507;
    uint256 constant IC6y = 3784116357853886908662703792470257115092241035418017538051092984694034158631;
    
    uint256 constant IC7x = 1482748518488017274760862034275870324964930834549363841518281589957275381162;
    uint256 constant IC7y = 17288592220163330124097854881963505457988655136338774124733749979412891514416;
    
    uint256 constant IC8x = 12085761569721063703398710767020508893290597346545496403783453389762835134658;
    uint256 constant IC8y = 11099664888267553278992772221716199410698648383625457147235063894283456253561;
    
    uint256 constant IC9x = 16465691492604629407269346227187837795971691391514129349461650702091318136944;
    uint256 constant IC9y = 8250100091140638040046993752643471896674983865613257741649571726295988398888;
    
    uint256 constant IC10x = 20715594244744606072530831218495732425533325462421626179669218685636181525479;
    uint256 constant IC10y = 21676674595520219740567792631379683013606819132867358184844710067536371320556;
    
    uint256 constant IC11x = 957237384323488323982485343772341321157434823903314787369241821201780750372;
    uint256 constant IC11y = 9955072699097150069740858331266962441141910798551171931533563353330204998479;
    
    uint256 constant IC12x = 11738485277711560149992056485177164803899123442133684232010346034104702615341;
    uint256 constant IC12y = 124296913689935150187300708750367350455640872635924390997650775623819687436;
    
    uint256 constant IC13x = 12839871573914251006352622197827513240258869533365568338218418465681166060580;
    uint256 constant IC13y = 7111458690339685548964957054986483368294239430142343318019158266708901619214;
    
    uint256 constant IC14x = 20393036730828165557648077620092379446438923502978068965826491993248071305878;
    uint256 constant IC14y = 8045813811932460750071295367062880123627540067243117909931163500000122030926;
    
    uint256 constant IC15x = 19096854627115243039308076253965895515301777305883707351499625250809628957734;
    uint256 constant IC15y = 21839522391967701986947341452218627572792571388799501715778463629103584390301;
    
    uint256 constant IC16x = 11770308846740294824671931003341923255534531617354868961313721726105069016852;
    uint256 constant IC16y = 20822064266094159096954019545417597498157286566541277756249600978818489134180;
    
    uint256 constant IC17x = 18816153445212761329861844598259728595453128745446282352802370441035906664748;
    uint256 constant IC17y = 17080536409833648921002847770091045012457422972936764877110843038305875218279;
    
    uint256 constant IC18x = 8982125232928347778560852154849131294752795585059362457598408490006283085201;
    uint256 constant IC18y = 15471522975031841187864844183562205670276557265908032520412741172154451526083;
    
    uint256 constant IC19x = 8554753478826346876540800631320838246408481663721805077370155910921778132447;
    uint256 constant IC19y = 16056134008809196906821262431712317105091825072053607252958939774323033689406;
    
    uint256 constant IC20x = 17670785782652077989994298074530652792128072012867659893838007994139664896182;
    uint256 constant IC20y = 16581525446735776119227248696441202762841722859758134442176610289000999573050;
    
    uint256 constant IC21x = 14287522475656124373493211129505821673898739872097519429675454720355205218782;
    uint256 constant IC21y = 2996118295799632131007842571492402921967688885855748372234542912962943318530;
    
    uint256 constant IC22x = 11773645628663926137877310460990290101965296152956549816585044455514464346182;
    uint256 constant IC22y = 5038664433131665667593871896502866432514080279695217324560056911491985458522;
    
    uint256 constant IC23x = 19826657923509578089067644283786093762149982235187237010686697998253094452627;
    uint256 constant IC23y = 1372176639826144251487732257964088028911007662622064314305332078296934852609;
    
    uint256 constant IC24x = 15585726931057335450075034084709126187637093672831504526358922571404728940427;
    uint256 constant IC24y = 16882605987572899544071884342627042778342244721698405376500170191327661438855;
    
    uint256 constant IC25x = 10052762924944292455846859853133016735137380457794874315071466975310878257269;
    uint256 constant IC25y = 13818062850766918266407188060502062777124363807725358706384666943879020808231;
    
    uint256 constant IC26x = 6417291247834632696285908623463317978787314023495823457110901631822937887564;
    uint256 constant IC26y = 18497063731573212259614688072969938450571232835176666028955383216768008277271;
    
    uint256 constant IC27x = 10272926897129595093717026983393120465811819391466833830532216465466142467852;
    uint256 constant IC27y = 2246855974764476453764652487422524331164489150355305132530045628906456417105;
    
    uint256 constant IC28x = 20065166860565515139898298218425305310785415962095524924756186013103927150733;
    uint256 constant IC28y = 1416754243375825893065753951228008759500625902549000135767637693224650967244;
    
    uint256 constant IC29x = 12058283574387154916650731152275484242779176941001890894298962437492959312806;
    uint256 constant IC29y = 1911132193763740551144586211928939045705718192463068710478635870715472028827;
    
    uint256 constant IC30x = 7080623377566133337328176092898363160987524147174962926373300096310502631119;
    uint256 constant IC30y = 7357587715049116547717983578843747223035635686330377325246998752919047817650;
    
    uint256 constant IC31x = 17178490229024167771303207752314293528016802155019946081083835213333072123686;
    uint256 constant IC31y = 4676347192442174699321916588467273995085921840795237755977589905311047480410;
    
    uint256 constant IC32x = 13180856886171845354579234763137044336304481464120041695310257765611375493024;
    uint256 constant IC32y = 21878150564950651301359670563085004629344043315008861018144907520687345599688;
    
 
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
