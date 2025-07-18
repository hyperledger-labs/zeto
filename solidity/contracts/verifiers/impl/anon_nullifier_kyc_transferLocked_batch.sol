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

contract Verifier_AnonNullifierKycTransferLockedBatch {
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
    
    uint256 constant IC11x = 18811933939393079251806686536583635329009286325557822914799036726343432548337;
    uint256 constant IC11y = 6079338643862489593054995226011662604430777410192687713395141068741157955556;
    
    uint256 constant IC12x = 21787522181680929793975512215339356401504229294383445631076069820051701465864;
    uint256 constant IC12y = 13755535518529933782526824134225188470258927279178577110003824526020999427519;
    
    uint256 constant IC13x = 15989857465213335247642272196957456935057695717857114414270966309343040446976;
    uint256 constant IC13y = 13612649988185151931988945019272347039897899604713452965199354195407015036178;
    
    uint256 constant IC14x = 5653179688141954297818189058435447279938777130269644579146169023084779882198;
    uint256 constant IC14y = 16983230401196699691329429820088044002671164883734295461742502268269047712947;
    
    uint256 constant IC15x = 3767018625976789602635409722040632369051904814953519186397098864088357721610;
    uint256 constant IC15y = 16250674387719550260692474512917497842197398780864214379127589727945921406369;
    
    uint256 constant IC16x = 16696250382337357078429643700672345632248091658403657975783069759616211533346;
    uint256 constant IC16y = 11967661710994040266906614906964531132818265507790084935679065034766551615384;
    
    uint256 constant IC17x = 14280933125732524223788091315233511500531486240665286683504493124541396825952;
    uint256 constant IC17y = 10849251098503009330976293286953029129841994252099674688238308379764991343004;
    
    uint256 constant IC18x = 2003988782634091471690286843480079766805346525609736160849496801954371942292;
    uint256 constant IC18y = 20461114214787202075972396130048619557678150673895252009247743877177614827081;
    
    uint256 constant IC19x = 379009327698184529016638167983550972355460801070778690627730395732720442874;
    uint256 constant IC19y = 19183034902125130904823141688649958416812034363132484765370082553696601221720;
    
    uint256 constant IC20x = 13451453195909914597880311528383004875533168051555128450691703888242423766821;
    uint256 constant IC20y = 13111198724397834979508385928119184016509963264654916995572825562426850553964;
    
    uint256 constant IC21x = 20053213013096319962794355229816255644367909210081869157839774514454208529550;
    uint256 constant IC21y = 5482258553741503910055970133341388107609395071348413804663724145020908867932;
    
    uint256 constant IC22x = 17622277195722215887254770313426813036239816307799660040255069953385865563893;
    uint256 constant IC22y = 11846854032296830757195889751708544173920655470080337240969924516471767028621;
    
    uint256 constant IC23x = 5661701685021326985285826311660182002499702416524546541611078869846392492380;
    uint256 constant IC23y = 6906483200009140687383774323384334701571879497524990403372465480529103558946;
    
    uint256 constant IC24x = 15897434201360693393557710806510318615046862273529825936118092142517056175760;
    uint256 constant IC24y = 14035200819285181695281941512303869071839196986512296130638890291666636459502;
    
    uint256 constant IC25x = 20515302710283658290943364260417446830629001550803721148964929347328032652697;
    uint256 constant IC25y = 119010374993293778790067203980823328643302652073155484402598113660631271843;
    
    uint256 constant IC26x = 1709404541480449290239377238378808939718678278653845871147194056499498072879;
    uint256 constant IC26y = 2542850681954338534868000165626433184866017205857166486680726473539192514810;
    
    uint256 constant IC27x = 1311458812998422733569657758834959906018587029627261430443702164400019485033;
    uint256 constant IC27y = 8256105471454898163782266320600126235640281944096351123546872521949800758507;
    
    uint256 constant IC28x = 17665577232918428049033308555556368779774665362761579361166875566006365944052;
    uint256 constant IC28y = 3972614767402843630393072702269647682465494319628799093449601045671060165499;
    
    uint256 constant IC29x = 16650586887427269266806101833764072252875285927332238745022876989110338104583;
    uint256 constant IC29y = 20173465816297192920027248666409956065485462268941187423382087860335239549919;
    
    uint256 constant IC30x = 5829605442203310013899326745145511078399830182654556307889058178988353338091;
    uint256 constant IC30y = 21602562023754597533040309864520308245976123613569959053777976238032228155485;
    
    uint256 constant IC31x = 20947056172256605136290670840921599144857364743734364782173937934273007287461;
    uint256 constant IC31y = 18029775001545450826062581362870732080587053116547082378041131563045109499070;
    
    uint256 constant IC32x = 5109649356536422702502845983648569233972069175625030192973899169709574543074;
    uint256 constant IC32y = 15572255047232187348273617677661984030925726105929303657499212661647718181151;
    
    uint256 constant IC33x = 21620647689432979678642226336843661580355560290055181822664467606974515941163;
    uint256 constant IC33y = 10132043789065841688989654905869451733374987027373533423102494546006317519167;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[33] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
