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

    
    uint256 constant IC0x = 18730365562460670693262104413994931450806245038342991074603702551145897446352;
    uint256 constant IC0y = 1986693462786640810426767380703648796254793448064011972797702315349632815679;
    
    uint256 constant IC1x = 16870277633353431582745757456114551991543220125333910640950906223222428246600;
    uint256 constant IC1y = 11763303529950153436167850321952253781150101539550635974422884602967931704529;
    
    uint256 constant IC2x = 7492139160872683688606874534836480114199794859856431341520104211895185468105;
    uint256 constant IC2y = 14813280517590580695434122977657319147316681485832507107118965404727369155658;
    
    uint256 constant IC3x = 10541581144684677245563567719009299858168100252975530701085184594846686922442;
    uint256 constant IC3y = 12423010272711947932214571551592641513351836227790619198037432672075736715985;
    
    uint256 constant IC4x = 20547896192668194748705496940293250349138487712849921548951135754449028100114;
    uint256 constant IC4y = 19380018835465602880669597932303754588516556906579156141998369090215267943905;
    
    uint256 constant IC5x = 3497934937374698861458082648510524862735904576538121762683780666720217803943;
    uint256 constant IC5y = 19358419081217534482456243431622745184097057178054796594003426205353779408371;
    
    uint256 constant IC6x = 1222897936315596126927341482014264094130869267003109149428325722924149269544;
    uint256 constant IC6y = 17679781720025747485721341325889092064011165262210358207787805343692728587982;
    
    uint256 constant IC7x = 11041809683612507882649266123341775357582386776766315442375607468404277810808;
    uint256 constant IC7y = 3008732445284909178337061418859181110676925452270748699360912213378069885455;
    
    uint256 constant IC8x = 16630729143544500445197281156182928567976009331142950423286548026584143292576;
    uint256 constant IC8y = 15034306132328240152778386149567086676475530969294098655761124191402795904536;
    
    uint256 constant IC9x = 6615333468444900552853977016808455783428501574114697288106266932708507275234;
    uint256 constant IC9y = 16816650594233630741501106371904203042605156553324566045620319363635119273611;
    
    uint256 constant IC10x = 19071460928967456065019966088451226983659340250314978502397921634594661669202;
    uint256 constant IC10y = 1521670794961263537550750326668826805956417807016117659581659908684770081357;
    
    uint256 constant IC11x = 13503065048439891388718111176106509690741021175819398503545089877797023109062;
    uint256 constant IC11y = 21886449946977333776493126189347465297374951226924400836489580610683320809827;
    
    uint256 constant IC12x = 21207934520129176934656802371776642692782385589914235168175964200339939576592;
    uint256 constant IC12y = 12880605648408212290905605663986734167225069025715670443566570886545917308568;
    
    uint256 constant IC13x = 4470575671008036988174637795369279391874438048582101033974877701807604256199;
    uint256 constant IC13y = 18492119776600731115965678551473405638918810395454855183680152154460897121480;
    
    uint256 constant IC14x = 15896685925262803443305015925978470163054181332116352355052362643495981122283;
    uint256 constant IC14y = 12995306051876963863577325360971867180815611496349906990707568670067468512950;
    
    uint256 constant IC15x = 18033269819713943042093661001497349646150994442336376524396808633510060209739;
    uint256 constant IC15y = 10544134106796260597673035021134916267400471907673885489742471019506346162054;
    
    uint256 constant IC16x = 2560487462210122212235515281409354012727657975873197679206210024307867678616;
    uint256 constant IC16y = 7203891636392831834367382568036152128346258845664303724798991382219198140918;
    
    uint256 constant IC17x = 19152890826403662893915072520364303958088562532449137774109654696678125025272;
    uint256 constant IC17y = 14889762080799876036275653222861494734297362274127956469643055095088097647418;
    
    uint256 constant IC18x = 9758106434739296718600285374091185957814948920034065486612914894379346523770;
    uint256 constant IC18y = 2147670986683875116249580783099190055441110350250107174763612136319896606412;
    
    uint256 constant IC19x = 3642620546912522589210619468605528736123026162679018804543412112786896355315;
    uint256 constant IC19y = 16561150047952056323284926141498954409510866389749288759478417043104414698685;
    
    uint256 constant IC20x = 13667792973725615282792658402930901973096877991170633528092314792437179745509;
    uint256 constant IC20y = 15176548165974713660213461970024778773513106069242307529675799567993647827740;
    
    uint256 constant IC21x = 3401740095211941486627752855321162965271093704950562655273080740404285838459;
    uint256 constant IC21y = 20813590650444227797445106581638546347192161163972098804515811798279457555196;
    
    uint256 constant IC22x = 14318409529302451147666664224574182782932618312346884007209627458110610824487;
    uint256 constant IC22y = 10286111568804634144434693103438828848600605075707241771599436632738726403506;
    
    uint256 constant IC23x = 20683375524482501889803664991669117821831708552700209056098686828065110662392;
    uint256 constant IC23y = 11285260080724050878304520482563733329085324990327931630100108118825710008932;
    
    uint256 constant IC24x = 14565397267148370495951677799635085595349972097735345951141956797330097348134;
    uint256 constant IC24y = 6309317111022179093636887003452256235598047420461201829067740835945116280014;
    
    uint256 constant IC25x = 4907509403349732366967349924067172021197773973197524936861077474343993802133;
    uint256 constant IC25y = 15442826017665100925677027196087926402204596775212426379303274305999559794446;
    
    uint256 constant IC26x = 20809625668304932099387825941210510287331745765481116747023403902550180813519;
    uint256 constant IC26y = 21787365501555085079883514800551444640048687379978439395138172888432053378843;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[26] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
