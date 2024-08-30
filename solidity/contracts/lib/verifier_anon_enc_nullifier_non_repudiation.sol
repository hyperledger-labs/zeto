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

contract Groth16Verifier_AnonEncNullifierNonRepudiation {
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

    
    uint256 constant IC0x = 7150602979198858324531264522050588047187864437625863115811019715531635342988;
    uint256 constant IC0y = 18679352390540645799385538354080686740567422609949222164932202910206044361948;
    
    uint256 constant IC1x = 20223737820803182000349268235929514427158015173398419989210846794808922069321;
    uint256 constant IC1y = 19667519192504952779059431068168374697689187072685801450130109271314785916816;
    
    uint256 constant IC2x = 7218856416869576295091037655873055759382316689150166584580005310257749626402;
    uint256 constant IC2y = 18250824158316410204270915259713657522920241651507178610002708235185510464683;
    
    uint256 constant IC3x = 10439404763847100272263651164703534229485312727099492374093433329301042860786;
    uint256 constant IC3y = 11622072859931810063779349289989468302907213687444913890818865119671330403457;
    
    uint256 constant IC4x = 3552958783616921573961765146209426612549096385286630602708070235513481501531;
    uint256 constant IC4y = 7983004287008394591564704928605579735201397516705121349773346875253626793464;
    
    uint256 constant IC5x = 7951915017279680503511105259632243418945970352099146353813397644881747832494;
    uint256 constant IC5y = 15580187666685695375077645460858502959715552703766566567151236942633699459128;
    
    uint256 constant IC6x = 3810270046381397249153853319380867614609141932721597496641486068943447688518;
    uint256 constant IC6y = 1789454555200419624433391404653719772125697252632300424422488567482953480839;
    
    uint256 constant IC7x = 16582813285159387606825357695015456733307275683978941475967473789385465564139;
    uint256 constant IC7y = 3370584196021878105671518949045188232217596798052799318361611555383941238644;
    
    uint256 constant IC8x = 6410335958983016577852137704582430672625504797739898593884922605316966411317;
    uint256 constant IC8y = 3561862755304133383761205380693974589872824992821334084854993222686099463287;
    
    uint256 constant IC9x = 141988548012661067741546583487301665549799271673511121018755490875713551541;
    uint256 constant IC9y = 11381489344212088827476994843766826329038542391607626896308015896573859623397;
    
    uint256 constant IC10x = 2400404699093079437844767864727773463595132175554480756228013854499052897743;
    uint256 constant IC10y = 16641639829319720713179419428727890115364728294133162095260244114066308681409;
    
    uint256 constant IC11x = 18819343891508230813261093280482339631274788730864531524665810946260398413656;
    uint256 constant IC11y = 939232547935730618247481870142928145681722172369345232371161962470473621455;
    
    uint256 constant IC12x = 19857900065761502826857489987079136225805396737807491159881256000358449239287;
    uint256 constant IC12y = 14866158318731160894408347837912771366289709323081067853939131732571761322111;
    
    uint256 constant IC13x = 654111863936885718257781142757347689010710641411633200860925542163991689666;
    uint256 constant IC13y = 11276189838628957949004554103071438492770960919007402030163410690856320771850;
    
    uint256 constant IC14x = 18969339244741250740753343010366495968956160496467373979506746525890248084164;
    uint256 constant IC14y = 16274901896353030323013083904924198681645770552447391614076698136484842443636;
    
    uint256 constant IC15x = 5364945303376219658991823159374369520315533888650937587824150006805793367435;
    uint256 constant IC15y = 15362324963834315062007218005904228090931585348452894617514266495515429954814;
    
    uint256 constant IC16x = 7706652216614464307929318948621370806407028558413501412600554293234571043615;
    uint256 constant IC16y = 4833155926438490231386220605163689437125897398884350656367983521056280632956;
    
    uint256 constant IC17x = 1149166998309009330377390731594951819957167640308447230581596039029228635856;
    uint256 constant IC17y = 17144496829204247748601976511350134750390256256716017203573337962163783928337;
    
    uint256 constant IC18x = 9682269424428793097631391573982450090008352352784483866555904822950699832063;
    uint256 constant IC18y = 7320838209204172545348024044818590112291242261458837363572039110259358463391;
    
    uint256 constant IC19x = 1605487566693008705655072065911584353872368504749215742640417657776546622076;
    uint256 constant IC19y = 2308043445104009725610511269022057743503782008796761536470885918528911939324;
    
    uint256 constant IC20x = 2240609051444145211347356467283693175838292400028588894056540660459977622330;
    uint256 constant IC20y = 1655940193015866774646205663901575824326740364428355076410141345515995005827;
    
    uint256 constant IC21x = 4853016079991973626530212093282440895734792373602971804488540915961627345640;
    uint256 constant IC21y = 7414374958276543278011110955360778512607526840415566794056500103235098338046;
    
    uint256 constant IC22x = 17185659180162348416125174675491441752772941877249583219738075242236758265273;
    uint256 constant IC22y = 9370043102883086031548478743900979288817657004984653739334919382623844393263;
    
    uint256 constant IC23x = 1586456447948676480094847981316788894535992294417175375639442973569813126062;
    uint256 constant IC23y = 2424151834815363943272735355039654154632114257560884077218826838523761765895;
    
    uint256 constant IC24x = 16231165842198799919638181935933189812441001519682385504931669473701873751266;
    uint256 constant IC24y = 17612049085973824664723374650586152547680864307435248820913416068867135991070;
    
    uint256 constant IC25x = 7483158710251990522291145254248684609165926444128647658988098156057140409708;
    uint256 constant IC25y = 1673962192351811413168005836076136338181422549980142181965437293503003409802;
    
    uint256 constant IC26x = 2039664876281990730333439428242031929108223709931553554336538537301070725071;
    uint256 constant IC26y = 14005074492108126348400685560436665000589249218363273187052286031208242682152;
    
    uint256 constant IC27x = 5496301741656297227126500517214062125367112090119824717058375335361580584725;
    uint256 constant IC27y = 13909185239757464535884774658879364364060378133383923006683376996195592981431;
    
    uint256 constant IC28x = 3408743782650195676340178066737516111388313667630761738794006191813037817996;
    uint256 constant IC28y = 5303551963048672301523729843825814073653383823758311162424233522116078262138;
    
    uint256 constant IC29x = 4211252801454076822373001217403810729274630805294678301066236345126168784094;
    uint256 constant IC29y = 8461944933834378462797492913096013822156422817717577384142109454005070578383;
    
    uint256 constant IC30x = 415070733097326475913681601424674794998572314824594858080542203826311964945;
    uint256 constant IC30y = 3336540749266077408699467353801385535951064172340925708089438425128638379875;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[30] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
