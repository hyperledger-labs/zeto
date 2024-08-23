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
    
    uint256 constant IC1x = 20546933274967030575375764341048743544324686989399521428648988679453729672574;
    uint256 constant IC1y = 12508114839394924272812953998788733726366166299611685224529406794282661918326;
    
    uint256 constant IC2x = 4824487154794987582159170214878483637081677445844342466036965508921744954935;
    uint256 constant IC2y = 20012603198977770575569235401254259856586296867286368963744054141596358017087;
    
    uint256 constant IC3x = 13085357126364845655853054082065212176091907021303910631162840784306734614619;
    uint256 constant IC3y = 18804105409926626067249386718984129501631713486331558650377019201942999164026;
    
    uint256 constant IC4x = 12528747712399663633358900443201580207926260592781923514277748953386784545366;
    uint256 constant IC4y = 15321444228429619370937074885438969957292587843245489130733239123958247484861;
    
    uint256 constant IC5x = 15170475719758944115055889107023002588735327166378614199529086892326318914036;
    uint256 constant IC5y = 8049620939170724410788843120022172935628332772087338494071162782553013962701;
    
    uint256 constant IC6x = 663212334310334458163964230706247925833592395378902112591903654282088356896;
    uint256 constant IC6y = 18754096412278896828863969347540361991262912756002947341277567135884137505700;
    
    uint256 constant IC7x = 20346276952621247154598337223390816957539156326029095923114626385997849044836;
    uint256 constant IC7y = 14162941292712917832463365746473687309497470625202464394839847050411947997730;
    
    uint256 constant IC8x = 9248410646176563087034094961520748988428755370925933675211425461428345682132;
    uint256 constant IC8y = 16296459388365501491563324106975466555396912797798729190644235870219784844785;
    
    uint256 constant IC9x = 9083178110926851007296941420083669034008805783810176535662907367069262727367;
    uint256 constant IC9y = 15272763540483910405229167164610099740544044456470363583487218543845277099600;
    
    uint256 constant IC10x = 6354539810570543825451702405001201431078418348494468217519344348456480113941;
    uint256 constant IC10y = 14540363042032996638579967445622113233183047698171994701106413211929582200504;
    
    uint256 constant IC11x = 15402490451329192726419686867507693651971698735095781620032357680507202300189;
    uint256 constant IC11y = 18776825231374543966149883553033553817834994082859635640079373756431539000683;
    
    uint256 constant IC12x = 16338362324500910711458540995499662519825721035310309481766476791493413746239;
    uint256 constant IC12y = 129099945110516700528901469394272124510164422816290268103236030804276978710;
    
    uint256 constant IC13x = 11686582902269214695960711960780724175103725174284777129365136927796869647584;
    uint256 constant IC13y = 16554706279775398925299029296786737540004147995537952533299814336712439852546;
    
    uint256 constant IC14x = 1391059691151041573765539336288822522255681866074476156253345556778984687459;
    uint256 constant IC14y = 16704486067549765602531907643704887579736996248257686347177482380766430723027;
    
    uint256 constant IC15x = 153683678643759940797793591527517619064774215867646038050151398326850833641;
    uint256 constant IC15y = 10230454976416116340677437871207060840790045686005977662254602253013714878079;
    
    uint256 constant IC16x = 3441020770783390721678420247863897181109537666056397599894290091843736969820;
    uint256 constant IC16y = 6055734993367315995358389133634934031147209478192955140864459573136358459493;
    
    uint256 constant IC17x = 16527482750362549411008515901030842811912583605167601846885701091727174163211;
    uint256 constant IC17y = 21585460817698485257775813166157933463370089150885624438358161246914839874341;
    
    uint256 constant IC18x = 5160955003840090131394114139067065035981538497817208563069514645767377705530;
    uint256 constant IC18y = 4181642833667505155381399863468629907868977089312944758512189096196173663418;
    
    uint256 constant IC19x = 4948442373592038976616201519852321320214615187307434803062754967096074408052;
    uint256 constant IC19y = 14438208973905067256163771533917323300141311808685588768679512426522803920513;
    
    uint256 constant IC20x = 21457772000319313553189685943142214457813393234972252846551500469611496162749;
    uint256 constant IC20y = 11933932056971968632710667592027741826157658464631123816752425793753877842729;
    
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
