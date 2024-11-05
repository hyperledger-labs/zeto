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

contract Groth16Verifier_AnonNullifierBatch {
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

    
    uint256 constant IC0x = 17597693319852546418407317206296148373698270858190689977875546982859726940491;
    uint256 constant IC0y = 8118153777833048296636432393924223445361273937934900816501954258825221765150;
    
    uint256 constant IC1x = 8633912278644610287475887713911534964807539155667235584423819625501837002741;
    uint256 constant IC1y = 12782270579821301562897542543693756010611609738889956205159332274840841047686;
    
    uint256 constant IC2x = 21700179077835246558971307380294521103286350535253985418290536465754023128379;
    uint256 constant IC2y = 15004626941619194278032579752844424149866966587469894640257965243821228927334;
    
    uint256 constant IC3x = 11501838067340941162826191089286590710505510954756365862310687494049124610281;
    uint256 constant IC3y = 7997218930568129577107427329463928855492905926410913006836967883302928159857;
    
    uint256 constant IC4x = 2340297852501124355160218493977084471403636217371842151303051370245556306174;
    uint256 constant IC4y = 9863219541214382108703698943644567235314194065893121209648036230903904489937;
    
    uint256 constant IC5x = 1514557942974715384289486242082461809010443828653577522593327574600071732814;
    uint256 constant IC5y = 16135696422408961088299374316721767948700913285226275787047603637037926153141;
    
    uint256 constant IC6x = 21583660777059180263521016565511699919946563507465320614743470341955906907683;
    uint256 constant IC6y = 12420920952797856254769118555919773550651865403918186904592992066570542038191;
    
    uint256 constant IC7x = 10980742372840171221043160666464637954411523283226958088726896817761761290970;
    uint256 constant IC7y = 19327866351494297293170821839716613926821786056891035015434265486829281639462;
    
    uint256 constant IC8x = 18596319256715964383973762645565923772534568677942378069525944640036890779043;
    uint256 constant IC8y = 19447620402352883899679811336082731725149153031151074048937695477884039400238;
    
    uint256 constant IC9x = 5559679317881047179184299869922431028130676567220325253628378681301647197266;
    uint256 constant IC9y = 20301435388700811403049117486769368990012535480069942056391021814722037812351;
    
    uint256 constant IC10x = 7571657016319652922725033260368571000168515132336399497806728851493407871201;
    uint256 constant IC10y = 9303694550986012160697743275451570337873556815268686173566177548328841022226;
    
    uint256 constant IC11x = 2446550097064438624164272232164992360904209286481246308083249175659936243309;
    uint256 constant IC11y = 13952886724306545172914688782906831120754511258313604146962566046021217003056;
    
    uint256 constant IC12x = 15513579294225333750341953110907484262180295975826474112568498910818467120141;
    uint256 constant IC12y = 17755495483467543522599964741556240041864668940308531491933194236777628838337;
    
    uint256 constant IC13x = 14921270977614594358885901465352981080077443695960568347364822787267341722137;
    uint256 constant IC13y = 7265811997019181552810219908532393806360115520769472008703961881020197478491;
    
    uint256 constant IC14x = 18901591238979503931761104350328685960555890089542990983976550906925802577375;
    uint256 constant IC14y = 15957159245558538761444308144891617845635823081255980836575523789801622807761;
    
    uint256 constant IC15x = 6327083277850305161961408310391501560154117128918787318655202465958819052902;
    uint256 constant IC15y = 11267385976440811132194917165538782883602618015104937816482305901965448363416;
    
    uint256 constant IC16x = 12554434291581926758867597638726576203128103310493963758559042269431790670578;
    uint256 constant IC16y = 5628125655849713504543560297714523950575061725489767760379523126819352632116;
    
    uint256 constant IC17x = 9588492836171905542633333778923307158140578503356221138991963159193312011491;
    uint256 constant IC17y = 18207942458272288899920702895671676283424367339187943892869054207389561277670;
    
    uint256 constant IC18x = 21310589795070469219276841023290803082445679893383287164983171175729468082407;
    uint256 constant IC18y = 11603534368164120490539046393784138071315977525409002871133057871231063399000;
    
    uint256 constant IC19x = 20971429406681867492532092565670290459657054408396879366963175648946806655794;
    uint256 constant IC19y = 16102312112362935425036365089764293838100907117761847642245355792687389221068;
    
    uint256 constant IC20x = 6373353557989085254713137953640135374089853728124829941416096300381883535819;
    uint256 constant IC20y = 1998211836282351344175880620945799215060616586455920296100792090999106049871;
    
    uint256 constant IC21x = 12333875653576608013717935760205183818165731091403602261824678074609065289039;
    uint256 constant IC21y = 13874532117247603520502913781872780128714390515026082149176314366522756145144;
    
    uint256 constant IC22x = 15594814678072126511611089471012881997994953243312827781966520286781138956993;
    uint256 constant IC22y = 11798552322923147379414313744918674147843948655421054730917088234193979549283;
    
    uint256 constant IC23x = 8447439813168437307300019878899514062912755675167883338934818415497297225651;
    uint256 constant IC23y = 6121165686329538759063975820107092861654730292113395185753663258626568437878;
    
    uint256 constant IC24x = 3370306254232236086173287395533557521636236575310809453092482676149019205014;
    uint256 constant IC24y = 17043632493577052467111669278849854823995607083570570757793792590973221841486;
    
    uint256 constant IC25x = 12034706062746579045761849873094174320018072123387894157340815364343681322491;
    uint256 constant IC25y = 5766344946552280398773374397811497404577836809787968210494878053430884860672;
    
    uint256 constant IC26x = 21680606806761591130157639346391512985583518533487837932295471730780711003956;
    uint256 constant IC26y = 17147021154864844500987770633524120941122830180132314145388568575460427383036;
    
    uint256 constant IC27x = 2952113066106922305257989816719532055252431306174543757438758594260338773047;
    uint256 constant IC27y = 13997833761639911054942937586090636771871978347177688931761802496685622639792;
    
    uint256 constant IC28x = 3655608940167328473712715285173111003641424207443936910838262526036059801674;
    uint256 constant IC28y = 21619132420937672870838247048657082623107347968031914471177278140759992355499;
    
    uint256 constant IC29x = 19566935143310829307965604920392497155822122331925438555163797055302741801348;
    uint256 constant IC29y = 6103710148163173273099395302554561403475260480145256070938176247225930950293;
    
    uint256 constant IC30x = 15972714510967671551656781026338698101049199818364901217930124132975919395951;
    uint256 constant IC30y = 8557273975939336053382396409176882521404086909184641362069057383102719156548;
    
    uint256 constant IC31x = 15882592379718701282498750007755113852359102540936302942039495202258329292207;
    uint256 constant IC31y = 14345579372819398020224297536615136940627411034595227225711370012240940972945;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[31] calldata _pubSignals) public view returns (bool) {
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
