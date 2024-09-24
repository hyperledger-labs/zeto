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

    
    uint256 constant IC0x = 3944445075228117821565047604309603820750410202018016930603758668358261843334;
    uint256 constant IC0y = 19711951516505465677916699605008107163330091662763114395955513140341801084904;
    
    uint256 constant IC1x = 10024224123696554332933959563789684919413349073272276892782203947930331299424;
    uint256 constant IC1y = 20519109008487818648924793377164949144965439508556951350226813126173272972409;
    
    uint256 constant IC2x = 1142173056187437846551638621853081194566151147956191754797065528924777141391;
    uint256 constant IC2y = 16031000099246098401525163660770199821855637849160899105526656734827553900160;
    
    uint256 constant IC3x = 7098793361958481515578594788921578408626331172533029034769487091259177553933;
    uint256 constant IC3y = 18915702772411484313477583493617809166313147544546482894351481289848486181796;
    
    uint256 constant IC4x = 19005971096426827854128837349584492075969620357702027599715901169439142039107;
    uint256 constant IC4y = 17532207718210544125714029032797641112877037912343528214735964170516471571921;
    
    uint256 constant IC5x = 1936021015178206426119341748943108180794913319638205912535284413609581525602;
    uint256 constant IC5y = 7967302136211472331990287049203658686597431243250329181974784035551218197358;
    
    uint256 constant IC6x = 9992554524016746312003618199582955623647477467519651007496252737703754630352;
    uint256 constant IC6y = 997153275981161531565982027728817123365375819829482012091549818270423282402;
    
    uint256 constant IC7x = 7712197579878897669743418158040651069819471864798300359532421509343128597573;
    uint256 constant IC7y = 20498432515857145880555260380958760566875858463167134358631571286825812813269;
    
    uint256 constant IC8x = 18584297171621908469803449997963801603823813214190833275839121570817476657021;
    uint256 constant IC8y = 2445386723403677400308664765622312273023037374330967243299653211986462592642;
    
    uint256 constant IC9x = 14133192108880623735273270944236158184105520798975796184751235384867979739155;
    uint256 constant IC9y = 20404122581377456550753849206502073960629482972120621127516616915445683083056;
    
    uint256 constant IC10x = 21620582086891038692341479911819403068709367310253070056590551238915328633223;
    uint256 constant IC10y = 18630174909646554249973638979405958638024971216151180247838752724473240059069;
    
    uint256 constant IC11x = 6342596883522327201634816902398912758838128458794280117859726335647563585947;
    uint256 constant IC11y = 2824016079010236948181204053147426819259406110745168974616977685808163801290;
    
    uint256 constant IC12x = 43159074190541489778203261134463021016969587199344421115375597833984885585;
    uint256 constant IC12y = 17350896801758852580882302620622451451656238190131669741645781468036782408702;
    
    uint256 constant IC13x = 5321216183955287064016722685217746316057734432786380277070838310613909336891;
    uint256 constant IC13y = 2334801222880043538040480613345627043718796655094720160375512110863749425857;
    
    uint256 constant IC14x = 3896684584635540489763375035772495988353847533817784420117417709276419469254;
    uint256 constant IC14y = 10946516808373943526791204345554417681977551778921357378409837151667749092291;
    
    uint256 constant IC15x = 13544430687582833351555151609955883457501780885438485005798150036967658669454;
    uint256 constant IC15y = 12107768107013128150501889862480428065699648543203108548328101125430038577111;
    
    uint256 constant IC16x = 20956163448328444323344906937345570843311197655153127557251918352529849395595;
    uint256 constant IC16y = 9598212570598439607775417965490373879497529804091617545914636036363751490464;
    
    uint256 constant IC17x = 8449456092675518202758567183735078063848547815110371262936870940442334259757;
    uint256 constant IC17y = 21524144134927604254378260953498622529381737979908227933427485851545206692964;
    
    uint256 constant IC18x = 393847122473837845101843958338171385083705802293147226527157239309984511996;
    uint256 constant IC18y = 10752382192217751383168301683456208551797510589007358704657988919297497446610;
    
    uint256 constant IC19x = 15228891166659766368605640799948864234093810898436039102385035716690203722442;
    uint256 constant IC19y = 10660180881739048220615741801758109202106271107338130476996669627381881546392;
    
    uint256 constant IC20x = 7611617887611604008702014435739239029985615041644938533863855284962222542764;
    uint256 constant IC20y = 830253140800199591016113383493114526088389823306942699451888210794961973972;
    
 
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
            
            checkField(calldataload(add(_pubSignals, 640)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
