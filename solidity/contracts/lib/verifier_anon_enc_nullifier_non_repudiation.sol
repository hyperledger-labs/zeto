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

    
    uint256 constant IC0x = 2001385234062673987692550429821815722863659431302298545583634907691892482680;
    uint256 constant IC0y = 14781110368514218587561375268471641777412620093484588360122287750189358006163;
    
    uint256 constant IC1x = 7556096446151950874840339036103156789650197148291803984785545466651498561337;
    uint256 constant IC1y = 6650962405978808836297634992928011561427876716598531736909858761293243721563;
    
    uint256 constant IC2x = 20038512891887596670632812249594702812590007142730486797720701790391611848271;
    uint256 constant IC2y = 20256333879439556091659528342474712479670113373689574853972461613489102930678;
    
    uint256 constant IC3x = 11443025028450071979050887288247099503200358162242990201001807478924029957245;
    uint256 constant IC3y = 13327499081089653748509498371491725809431707733316023854978980316109824479432;
    
    uint256 constant IC4x = 7624555235387495367935127170697828159269695097559331594010293813960319884875;
    uint256 constant IC4y = 11137415159601647519869398005771976201119348510679516196579735433485526675104;
    
    uint256 constant IC5x = 11087871541207315606725362171392044593868106261660454382374333971677088481491;
    uint256 constant IC5y = 19340732691909630389342213036129595674096169741788037180538629969520804730266;
    
    uint256 constant IC6x = 13583100217505575966160350019452009194048692549120513539268963698775438650630;
    uint256 constant IC6y = 1641448164312944528199778933389766215797047305335726307565132483593471411259;
    
    uint256 constant IC7x = 5585922134673658233801959463798429458921409250802635584596282098657485406976;
    uint256 constant IC7y = 17863740184730961269858749548594348255637841211596681301637226124021328969527;
    
    uint256 constant IC8x = 21099117100082313827099466608703735183105199543855999801428992850216941565751;
    uint256 constant IC8y = 15576013126025048602321604727127815002671640946151978810664235227249216762668;
    
    uint256 constant IC9x = 18537449506596155106234105147437034972479117580979497781576650676303501386606;
    uint256 constant IC9y = 350100634610876129956205819597008741801048830980632745488137405716028556360;
    
    uint256 constant IC10x = 6230623393922273599156930456061095773845299179410369329393737749736010110232;
    uint256 constant IC10y = 7212836541072467658356691744886683497110671517013247336842773780534221299897;
    
    uint256 constant IC11x = 11500834666249894206517075029818888357187680835157036595150320912042566569794;
    uint256 constant IC11y = 10625222236524492807356740110079370208109188102418579704419887770202367954617;
    
    uint256 constant IC12x = 18076381111049825224143411559610114673113690783792848328851083183120075264231;
    uint256 constant IC12y = 17241151807696198062216881364680561730664367177940656173116091242366074985416;
    
    uint256 constant IC13x = 18451364510169040263505387567915153954911354482207025092421380365896418091293;
    uint256 constant IC13y = 1263492930065030278481614479165428450888795551755252441204101302538824235427;
    
    uint256 constant IC14x = 21557271937691250944604817969075776869572327921381748598093805058055364675382;
    uint256 constant IC14y = 2836455568081527627449278837231945506251083433638642473587653523569100114637;
    
    uint256 constant IC15x = 1830909393324537755555709765026971523236789684214153554380484581693135723935;
    uint256 constant IC15y = 21068113563481994679245374860355836161021339697312248094433479370934515451200;
    
    uint256 constant IC16x = 11323220431842225102481559113791044767139113164625700896793186678487798847741;
    uint256 constant IC16y = 5097446564327053568314477297310301901562468521373501658833148993862660836660;
    
    uint256 constant IC17x = 12493914728195496222179273208316003621624853295718398849363619148486542758948;
    uint256 constant IC17y = 13929000355918240912783087207522794697670133160373892491732663590746265725429;
    
    uint256 constant IC18x = 12196477888450095144631113248433088165567496228974853259061336126355061433132;
    uint256 constant IC18y = 2593734875576368754530901115322716277329929337821110679278653598281534577027;
    
    uint256 constant IC19x = 19157133362169706067425507599439517487346982421360162947533618038435688460883;
    uint256 constant IC19y = 2197367399999210168073557297719654236896968421428125867638562390043049905927;
    
    uint256 constant IC20x = 17676616893182722038184797005091187792591287172525628880466940529019202338232;
    uint256 constant IC20y = 6421633775748634968225616302389477201287861997904078481265131439393505179076;
    
    uint256 constant IC21x = 20385997122851512380113704253865887187323114383215015031461647656151596858613;
    uint256 constant IC21y = 7260981333215033747977825638549821485672849697997346397182358438850672343241;
    
    uint256 constant IC22x = 13999922842165919432862939195355754862945480183509940013200483835153838109551;
    uint256 constant IC22y = 400163328287374113717183118590344728496928291194359253961837679770283021908;
    
    uint256 constant IC23x = 19458055711860628943708443169030611608754382401303100174185166022968492361607;
    uint256 constant IC23y = 2848381386694903189363259153112379900106707228073594084492169187784172949632;
    
    uint256 constant IC24x = 17531046966640079573316289123751632058366589650567343583061752365060469197314;
    uint256 constant IC24y = 16462363270846382286366303329373338154741806960837952304208472648401068312723;
    
    uint256 constant IC25x = 16798288305215215084918804845752642717144659018137592097061628636415784683373;
    uint256 constant IC25y = 11467990998187098132358760989945104347271362685533654409959629758948243439095;
    
    uint256 constant IC26x = 7131341148725923062606977990723516820447565213228296843410134097107044444246;
    uint256 constant IC26y = 14786619507058088049423601195439941140727663081696792947069507487258897239548;
    
    uint256 constant IC27x = 20856664152702038152073898073607260504713974915497170470013213358589148195496;
    uint256 constant IC27y = 16289984255803231565038245555195542047629395546572280647123389161444417971802;
    
    uint256 constant IC28x = 3559951894740717395468316711337065168904775438446206161240136513659995988852;
    uint256 constant IC28y = 6220168565730984299204583459599531536467445850896316477312219438812674598134;
    
    uint256 constant IC29x = 10045785015361146439922103880268122753194557614584401670992041149651174938426;
    uint256 constant IC29y = 3636243097487537009996004046942013245175535333592383120320202659005095158940;
    
    uint256 constant IC30x = 8214743474785854080987884698401706499167027176616015038372339548021576538361;
    uint256 constant IC30y = 3428810406315992284055783425099893053213425751412394897713941587222409549759;
    
    uint256 constant IC31x = 1267549717859668451439566862713405719893723955764005218098007961338892457797;
    uint256 constant IC31y = 11758429816001925927960801327235916813596014397726174910675235018229427539532;
    
    uint256 constant IC32x = 6711601108141956980424669452891331514596660008992284700508667715390064956555;
    uint256 constant IC32y = 11191350487359002842496957330936506202001026948170806569580865351098880972781;
    
    uint256 constant IC33x = 6969583499031249624725786651021279938665233209619102259194496777307711531318;
    uint256 constant IC33y = 12619377049317739439680086336988760205149563407437972645741590800514719303024;
    
    uint256 constant IC34x = 6583002047962971819178024209787355947253075667002085983486858682679610415792;
    uint256 constant IC34y = 7277493903576658302975604936999804116171838874279241410915597563901311265688;
    
    uint256 constant IC35x = 8409562441091628398649064783168407582528957269661520187235453496268334600306;
    uint256 constant IC35y = 3882989998725918782530462650946481670824992493219037513789268126696771430348;
    
    uint256 constant IC36x = 6455316605595738687684242950455236432385232714912342332308527117235221599782;
    uint256 constant IC36y = 17947945135063582453644296713215480011345375622915077708579449202303948211154;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[36] calldata _pubSignals) public view returns (bool) {
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
                
                g1_mulAccC(_pVk, IC34x, IC34y, calldataload(add(pubSignals, 1056)))
                
                g1_mulAccC(_pVk, IC35x, IC35y, calldataload(add(pubSignals, 1088)))
                
                g1_mulAccC(_pVk, IC36x, IC36y, calldataload(add(pubSignals, 1120)))
                

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
            
            checkField(calldataload(add(_pubSignals, 1056)))
            
            checkField(calldataload(add(_pubSignals, 1088)))
            
            checkField(calldataload(add(_pubSignals, 1120)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
