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

contract Groth16Verifier_BurnNullifierBatch {
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

    
    uint256 constant IC0x = 16145782326416711585410652490927016730994192048931389076141852459867138314925;
    uint256 constant IC0y = 5923884757956853161054859540792447227875120719818860198944653341258778422434;
    
    uint256 constant IC1x = 8739477590033996794605507631157477453580828845047689041668220275590718610116;
    uint256 constant IC1y = 436916898753240909570338995179001922284093538089065288893317268668686786781;
    
    uint256 constant IC2x = 10214764913495393275110406470348510762568470044184780613082762142853750511983;
    uint256 constant IC2y = 1015355910196998444000046692712676348083951113446057276046548136793204728501;
    
    uint256 constant IC3x = 5370172364010528790492773746793802523386119277549704921955939057810498583580;
    uint256 constant IC3y = 11497498121353806220052687428295386381624103597876147299236881805880035687390;
    
    uint256 constant IC4x = 881210031662223470401764363568583544431285918450706829767876022354636845;
    uint256 constant IC4y = 8987524943787988239905375083003336858893383763845889594581633793032165088983;
    
    uint256 constant IC5x = 9668512000842598899168548004312434603105597932116690460311559179116507200667;
    uint256 constant IC5y = 17477085956905407021927166056789958524374684562769512662252378552199477059399;
    
    uint256 constant IC6x = 2997791632373660563268633023030322401156584061940789533471341483048617875514;
    uint256 constant IC6y = 19481158112256679166378324274222987023658552718332419257238506023691155176678;
    
    uint256 constant IC7x = 17160797234094988800958357218288608570367156808222659871474208148919837705202;
    uint256 constant IC7y = 8873243124940821386536923202218939735970223596398186859389862571467521505103;
    
    uint256 constant IC8x = 9812407221909897512888655470645704295124730556960355986154196811226036484690;
    uint256 constant IC8y = 8537246357259319857089022718268487737890599162215029391837980227325451004877;
    
    uint256 constant IC9x = 12524157572341004742473427571672286879211121490938028028854159854802227942418;
    uint256 constant IC9y = 12928273227093326486785935473743249131950595841283528377703126624778309664455;
    
    uint256 constant IC10x = 520527148358595193999806222029313160982435252814342729852692550722556556003;
    uint256 constant IC10y = 14490213407758602220616363095542744905172763044099204864039438413743166169549;
    
    uint256 constant IC11x = 12551342059676694309788533682702532306465948294089173388644612034128700783403;
    uint256 constant IC11y = 18280635323628028347015637891496624929754242550089787991959851090587962477812;
    
    uint256 constant IC12x = 3657805733693330990559108858251358769797151062653299715693207996606191519746;
    uint256 constant IC12y = 16444448803973491735562495978147854348860621491067725622234022542605613324387;
    
    uint256 constant IC13x = 11824506674165245283379746327855401484031170714102574442137688924954530780809;
    uint256 constant IC13y = 14828550767825722284939486141887223792169979822715506193477109365273427871342;
    
    uint256 constant IC14x = 15614646772328258656923194456908048821926710200564312937994419873726169434148;
    uint256 constant IC14y = 15728361544557566930092810724234609787116203338999278370478065815880464079313;
    
    uint256 constant IC15x = 5272543643729788756154177987725211814982525499455446517358031013088156853716;
    uint256 constant IC15y = 12216846035520016501374162667966036680282160730566420464820814474007286929997;
    
    uint256 constant IC16x = 11536391581960494908267676551093500503259444556176626024910390137177299230264;
    uint256 constant IC16y = 1321905702053396052845953664977600194043944772918634315252625931197457815097;
    
    uint256 constant IC17x = 21717851719794007534946108637577279914369058718127060371839240189101647857095;
    uint256 constant IC17y = 17292723936715513211897456998626947474550758242087390397012982525742860594836;
    
    uint256 constant IC18x = 7175882623485095521517134420294823880240436067376872684798228730294081094119;
    uint256 constant IC18y = 8132872217474157115265293226282824073097569282055500334933692827181319368528;
    
    uint256 constant IC19x = 20487151632792335540169191480337764600807386841424461228048597469235223096516;
    uint256 constant IC19y = 4968685972984329307653205854765641476975633943625826516887778538902024324174;
    
    uint256 constant IC20x = 11190781472474343078614733877861242749184574116058072944950684015836184586268;
    uint256 constant IC20y = 20298353218806613300733254896337172429154295486403876009486329159876422171119;
    
    uint256 constant IC21x = 3702867892381016642721861757705418652837612416369410004645034977646739188769;
    uint256 constant IC21y = 6387068324455773805187082267330068181244083514243419085917249045175411179371;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[21] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
