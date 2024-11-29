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

contract Groth16Verifier_AnonBatch {
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

    
    uint256 constant IC0x = 14401916694900248086984454610617645117186037810025870355725588875905411527905;
    uint256 constant IC0y = 21823139981972768925181597835606667363291590735926744185425609626967895836641;
    
    uint256 constant IC1x = 18152399282716158169629531201439344161063103224251361362440246670930516009303;
    uint256 constant IC1y = 6080278265173093538537246863599160169974109935068305121259074193384775431363;
    
    uint256 constant IC2x = 8297218266848061835807071945554336477046207943620428501160290285825071517363;
    uint256 constant IC2y = 15656222378314004248176477825191755476212778291146638786091437963148762568128;
    
    uint256 constant IC3x = 3047434740237115324297422001872346293290441872228378409771516453051049454159;
    uint256 constant IC3y = 10541096522864074461757896295030226941094097575004052502097468583817879074093;
    
    uint256 constant IC4x = 18415204963750428001366853480098284329225951295307528124155234247674301562276;
    uint256 constant IC4y = 18206845444283706289783054066424364156383540489856915668759698699066029015528;
    
    uint256 constant IC5x = 5848632330022221449217083844906849578988699882267611916943101169293886327152;
    uint256 constant IC5y = 8525192717750394881723959129538639054882628564239664911410730246619999848599;
    
    uint256 constant IC6x = 18737933721565426341245741788052591666191809520781288299820522320094073877002;
    uint256 constant IC6y = 17893060166280487897808816982590615297284643156483941137846260492062460760617;
    
    uint256 constant IC7x = 19098445952237615276849115001752018549598132495817554411626726814628060269826;
    uint256 constant IC7y = 12055887832584514874540928561552980046792594771344397625875810924512944008940;
    
    uint256 constant IC8x = 14049087315628302176692100175044083505908130478745651601589669404557285071536;
    uint256 constant IC8y = 11760483736571233695765389297508375430401740670321979310551162352220705482170;
    
    uint256 constant IC9x = 13933845163646305706487746770461738555628647435735733692423741028126085769120;
    uint256 constant IC9y = 5906072330325167864469019724869377799273255560000238774314064772801265008600;
    
    uint256 constant IC10x = 13705817542782816555899655377219516947625498453397622184137502850319776285664;
    uint256 constant IC10y = 9042948681425040255034970979470429950080719583285309041655605511548953117983;
    
    uint256 constant IC11x = 21219849026857904949098640161461967736586495130286899335070690044195456905584;
    uint256 constant IC11y = 9738292818521877248157023071103026883633012472866114286481112790569861434809;
    
    uint256 constant IC12x = 16821584442373432772708439871996312879436027142106307298789026044142912059297;
    uint256 constant IC12y = 18179456728684141852474805451524977640053894307290781083105544127773978083590;
    
    uint256 constant IC13x = 18644980581060530311357977147481430713902817828375295403067823676395599257852;
    uint256 constant IC13y = 4274710606613794907868577617888070748913495219029409238664182414438828140774;
    
    uint256 constant IC14x = 1670061012290661486355607450319597799823993362799528125098867249745378187092;
    uint256 constant IC14y = 17357067744661529049119254714176244266487122291167133704079413719073749738908;
    
    uint256 constant IC15x = 20214070364826093890785202955205369405718408221128285777814067171054281417142;
    uint256 constant IC15y = 6676623764796503794882178144016983490948422057538987148553778809368627351866;
    
    uint256 constant IC16x = 19188803159885638492346037355574861082584717060749055884680169327249938506224;
    uint256 constant IC16y = 14635030226769140385410527971428459895270353563660740462654337932363700995073;
    
    uint256 constant IC17x = 1032439080446701812081769707385444592210021579802000978244234134167421120896;
    uint256 constant IC17y = 20080022736872634490249028574119868255366821827646688359584040403863693869436;
    
    uint256 constant IC18x = 6320239074134649680926373071446503578744317667951777657870688787798460814779;
    uint256 constant IC18y = 4076247364427329948398771036551813672936759695367436275660900533153237218613;
    
    uint256 constant IC19x = 18319045025948706149806565908584079240069485862781923810594761414646236403507;
    uint256 constant IC19y = 1443810282819553906570438933381282835687988434540658729326313586117183414978;
    
    uint256 constant IC20x = 17616701033046011221658156058153126401552902469497703215789359069808206367708;
    uint256 constant IC20y = 7948235851932996085506931557727991080994605820774849180821643683325993620091;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[20] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
