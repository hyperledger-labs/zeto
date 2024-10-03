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

contract Groth16Verifier_CheckNullifierValueBatch {
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

    
    uint256 constant IC0x = 20671074467579734857847596547055266445328533762588721268519191875350059053891;
    uint256 constant IC0y = 14951098345322796073027366584310761044868926985657977459139078894481627655461;
    
    uint256 constant IC1x = 12000081248186983269524257052000761064901034818507685659049644161122941063341;
    uint256 constant IC1y = 15516971062665917073090328459138065004596246882492513196262563532230767389353;
    
    uint256 constant IC2x = 9411111032740111602264855148385468328492259422723597259385251613745598803902;
    uint256 constant IC2y = 10323155201450014604301403915496923225659511949572802661966430087007178746441;
    
    uint256 constant IC3x = 4438847732901674872128718308489179804393784494012127205086961117665904894192;
    uint256 constant IC3y = 7430531453405117598938421321593673956070329677208870594925362824944496151111;
    
    uint256 constant IC4x = 2395120040465205201096667885252276606645316331032988003167679478054139898877;
    uint256 constant IC4y = 14448366311941437868185353072645393328711231401925491134934298524562784274462;
    
    uint256 constant IC5x = 13445677581031398831817167387998077245896166063464307566626433317121928548858;
    uint256 constant IC5y = 13902400719240728728437612577162464173527233703886931321955943252958646992511;
    
    uint256 constant IC6x = 15641654430273462801884123825735380328788465741346176351356205589585591382537;
    uint256 constant IC6y = 8139850515789596472180180792818545785157943800149252751717392103568781234161;
    
    uint256 constant IC7x = 14050096082523710141776397917128550695911592862807463733468997209701682217863;
    uint256 constant IC7y = 6901766456320629799934175965140510580558270796917425129954992400613270177847;
    
    uint256 constant IC8x = 12731436494425511204592700949928542091214640520850023719195462862199345771601;
    uint256 constant IC8y = 19120295984411495037887570571101234304735996780135524189512745912549942321948;
    
    uint256 constant IC9x = 18277966489668893230779554667054735652643817777661497642941039904825866475778;
    uint256 constant IC9y = 14776318209502074904311976810878471980321185136711509936306201830834650750985;
    
    uint256 constant IC10x = 11393441297861142395248716090957736857800669691486901170239864009237766837733;
    uint256 constant IC10y = 4669633111807398549423023745625200983024113696597242886776080701570600095817;
    
    uint256 constant IC11x = 17094019090056954918811926108534746962919149124197235929911157344230501642917;
    uint256 constant IC11y = 14674368842335287917470374822844105391742093461604374599471429840141572040168;
    
    uint256 constant IC12x = 19692688396724133495482002416399398592514532066384925082407645678984419317473;
    uint256 constant IC12y = 3605203667012682912469870143041663147227348414852241639025768542294557979471;
    
    uint256 constant IC13x = 20628982961670697756256724718272051941421624806419790192237263009313531587753;
    uint256 constant IC13y = 5403716199591168683890485313474651075202577022988073697830104927568491753927;
    
    uint256 constant IC14x = 21679974290313205033014132589719764884061756549385623306128090282856163701618;
    uint256 constant IC14y = 15451053794872865538119516358230526850276194265855889349229313173675490614973;
    
    uint256 constant IC15x = 16603737745500308717002054968060166864459062746665998233180858889452052686118;
    uint256 constant IC15y = 750549697690004286406850800760928901821286836108997012362232119165590942167;
    
    uint256 constant IC16x = 1359311639973519852598165556788860563250638498571805076085313151321480630172;
    uint256 constant IC16y = 4831751294456710953219978069057466405077773094664792257088750356636328425109;
    
    uint256 constant IC17x = 10246678981614529245614748704049790844676680216805003850578533976065639967924;
    uint256 constant IC17y = 18673996210719422229181910852659583345325739558179830325503226296557565439035;
    
    uint256 constant IC18x = 19915227005624332214251170233702382833969373708814987943248729626521801446050;
    uint256 constant IC18y = 5283839256348009268722315411106479297473851835680129259755232084561721766803;
    
    uint256 constant IC19x = 13883604722689792226764138263277808397013882375589363868621104879476228674022;
    uint256 constant IC19y = 7236730039787803352120531558201495639173100029441266845857912822879182728155;
    
    uint256 constant IC20x = 12481531748190575843330873248871107942932072373848033146722006789119150232291;
    uint256 constant IC20y = 9631254126711952993469771781559629372506383041947195835052653817320975402032;
    
    uint256 constant IC21x = 17481080981288359886217003385152346766741540645180108972693789761048559279376;
    uint256 constant IC21y = 7825039381905782374744115652203827737598831456021283009023141915867193175692;
    
    uint256 constant IC22x = 7849237446611626817070212201485848479849355440996513672685177687294263805454;
    uint256 constant IC22y = 16515874431405097920776203066333566915839614045778881194348792214569056984691;
    
    uint256 constant IC23x = 11857707391098615847106972237544828768710884349097096286759498433883002113991;
    uint256 constant IC23y = 15958999989731507948927930508670148671289317287181283284670403760528825439958;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[23] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
