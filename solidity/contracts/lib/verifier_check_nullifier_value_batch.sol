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

    
    uint256 constant IC0x = 11215632211605849777997006525456347967737448500007318091927705268733774154223;
    uint256 constant IC0y = 17699952619297303965304183681916877388432635137985585988606559487142475405763;
    
    uint256 constant IC1x = 11548095286197359121160733146834476640223930159466939844027933075934552511428;
    uint256 constant IC1y = 6288656266975730553736144969554904041513279189257442776734466277026887428385;
    
    uint256 constant IC2x = 18926854554953490053576576035107942442382117200777788107144510370783807097697;
    uint256 constant IC2y = 18289935522389488193993054449478068628556804995469571495694897572246135448973;
    
    uint256 constant IC3x = 2771233727558080770853129885714002927147125934391829427537426622342329046758;
    uint256 constant IC3y = 5214926352943362617799594830977548938122254343767107957731936384811679914924;
    
    uint256 constant IC4x = 21847698266056433410747936199079865606982901377721262794677774638804474016719;
    uint256 constant IC4y = 8147615275872120936254385749934320162961507021560542223066322259961345459136;
    
    uint256 constant IC5x = 20677470849417460934074316550301050006619653890702542532155516395060068184532;
    uint256 constant IC5y = 14951640248816265062700558139964650163968515368047361399041201551655167160143;
    
    uint256 constant IC6x = 13552674142114362873571479903862068723991679433261012406669406589085738389659;
    uint256 constant IC6y = 7981710903746946083354871005852277776743818441143999574738020051202535606933;
    
    uint256 constant IC7x = 2843494076733793387882091326156241096225727929348442160495843068717543839521;
    uint256 constant IC7y = 14557654223965043420646594567381219413527997179469070491574680444809195848971;
    
    uint256 constant IC8x = 4175404132208645428143528244972201934610322248514230591679427294477775090476;
    uint256 constant IC8y = 4013408769686153582064342212992839071277122314070152381839708135070908233405;
    
    uint256 constant IC9x = 20373089047507286170686013342501109233678082808382044266512396006289848296548;
    uint256 constant IC9y = 17414519037252783531098115688093063546013495710114297730709365743261124408934;
    
    uint256 constant IC10x = 18404652336430160384100638626193336882585113518149833816959325645823341687636;
    uint256 constant IC10y = 8137460239724975063676137530784339741015268295017803709669034144589360083276;
    
    uint256 constant IC11x = 13387772462482787398891173736297802001331602227482843796433543930845834622870;
    uint256 constant IC11y = 14251235131839391379589815502073622557073889987627793817902006298379525694305;
    
    uint256 constant IC12x = 20865452764368968483277128844158136885156922937779917366127619931017305838384;
    uint256 constant IC12y = 17853170680823374103828156105205829685852301408973246894017715214149058802045;
    
    uint256 constant IC13x = 9853052414354858016630641887517965504857357355021183318544386710740404641437;
    uint256 constant IC13y = 13146092501012325526897894082012191085118374563909694635147607538448073891621;
    
    uint256 constant IC14x = 2826204081145110561887126072614799213904772886576324960398804191585387429754;
    uint256 constant IC14y = 20321441752256535051701734841817178137635126863293665107747342993271525607814;
    
    uint256 constant IC15x = 9264128410271638041318342513546840109915920917673351880950167980324310412014;
    uint256 constant IC15y = 5380502298543509366643708116580810604911173595451307803675768078234246959789;
    
    uint256 constant IC16x = 4479343358771134075447296531862885036260188197397900811748790404715264510048;
    uint256 constant IC16y = 16673821339016242146065316462622452546805721830155001289853613360459978869727;
    
    uint256 constant IC17x = 20771838221883342227665651895035860952654473843853849403306865012146234872629;
    uint256 constant IC17y = 20110759151618177312269262403632221117051159160579155030673784750617199953714;
    
    uint256 constant IC18x = 7874670996063895301022675254507504023996844454270681310245045360371548207593;
    uint256 constant IC18y = 4906272562446411959996790191782933892624669175959999396258173204803057747802;
    
    uint256 constant IC19x = 6718068758839848944456102553943243734192494940351219060147807098504340933145;
    uint256 constant IC19y = 19749712309929432365633731307262416305583098811676296992735054736542353771846;
    
    uint256 constant IC20x = 12176774966903129701010883373268971316874402759136524023543221961925717374009;
    uint256 constant IC20y = 10316950245175186647318117251800593818959589497566969142905778576985501289094;
    
    uint256 constant IC21x = 10783521488815019568722998972427903675610566048605720735071487149054891972189;
    uint256 constant IC21y = 19897698431379210023931523484482075971373595776099016183701689207454616677220;
    
    uint256 constant IC22x = 5686192372711372618497346248576535688658010637360628945740213576938981144374;
    uint256 constant IC22y = 8257210265176086375186156384792077707461793999396533257754807652338899261851;
    
    uint256 constant IC23x = 5606244713006994272354131277915058148426505191268835047965998884675502616031;
    uint256 constant IC23y = 2348995245049377607506145290150107096011641146206436923515875214498125762021;
    
 
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
