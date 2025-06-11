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

contract Groth16Verifier_AnonNullifierQurrencyTransfer {
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

    
    uint256 constant IC0x = 13635976891038895965304405455687695604161643147588034000723976011170881753207;
    uint256 constant IC0y = 2295105831078380459720165564197192049189742911750998935499207900046109370681;
    
    uint256 constant IC1x = 6312882065155882720598983682663479588995816838059813969192406160803077914499;
    uint256 constant IC1y = 3467424270201488615336970846278886237820515062613341587935957517256569560160;
    
    uint256 constant IC2x = 2340045210535168528696453002683724059327815937639521869064759108626548611762;
    uint256 constant IC2y = 15594347735635427953555633795667775724820660723162253576754697904055132294106;
    
    uint256 constant IC3x = 16730308400638275795334424687845625740112679984587116422965222008918300932476;
    uint256 constant IC3y = 869081749674420823618639894768135794363054068768644130508278978450160817305;
    
    uint256 constant IC4x = 4669021999618332842111297237822220131919139778127768128575283558509927277674;
    uint256 constant IC4y = 7907595845783291353205763136995453835880760826719278328649452537632681416755;
    
    uint256 constant IC5x = 10432945634447581941162164213886006096798656172751607351436657780228093692515;
    uint256 constant IC5y = 6191196131587837931543498222501316707033396803159817624677904468647196640802;
    
    uint256 constant IC6x = 4356536467788194316192634952047097926886890327641720184631449694842047091687;
    uint256 constant IC6y = 11019472365712518212801543335522185703900965087918832186436566127047459843860;
    
    uint256 constant IC7x = 2872074321274894131101826511981647981115933321155679919113312240660474589509;
    uint256 constant IC7y = 9341663453134033870252845514989924546503168906315292383485311982103668582553;
    
    uint256 constant IC8x = 3070196049551911724393779639724133130855107884646083117470284231049120066230;
    uint256 constant IC8y = 18789604415054217090171719272938353609189279650322326291215927348507317164244;
    
    uint256 constant IC9x = 15750399672234391776333364629005712709845252193916075428233691972692445852298;
    uint256 constant IC9y = 18423262192835565168546896063371215262397605358669693856524746653127425231385;
    
    uint256 constant IC10x = 3682005793707331536199261936234098926724981032986590762879503209386134450800;
    uint256 constant IC10y = 17086584299614674187956150141041247038096322505393052316536554274041984484931;
    
    uint256 constant IC11x = 20432187304600556707641035516806028452515603631919131068623861171496554866658;
    uint256 constant IC11y = 15431207843370601309835485933585802905391887806349128549201409798122649513538;
    
    uint256 constant IC12x = 14828079497038759012948853427433914424280011745578763867802728469926324084640;
    uint256 constant IC12y = 18195348920407218920486077366661290688431316980246020464091084531013090659404;
    
    uint256 constant IC13x = 4829192950336809352671600447988880621978406219560721630179346386308016475062;
    uint256 constant IC13y = 6114355364013687896656074456036672202497037530780065903640352232674844397108;
    
    uint256 constant IC14x = 8324666190318064205784233095826088471516851348509395433245353596100409132743;
    uint256 constant IC14y = 12780701470056538425150303814924947877480011266159251684736138007403093963031;
    
    uint256 constant IC15x = 9342909208122985133693838594451073914777411506859775559688891315781895684387;
    uint256 constant IC15y = 5802372647884871208329626284837573890528839424645257989524609112059399645194;
    
    uint256 constant IC16x = 12687156946447510380067328786620293055275736233415897356006609172315384083411;
    uint256 constant IC16y = 20272903482506174932821931735328816965190342198567017398997644832507555037035;
    
    uint256 constant IC17x = 13006788697596817510455407323937028690158565905972657432041655864960677521893;
    uint256 constant IC17y = 12834868407655786098822394805080661124518210343570120517180876013505952473828;
    
    uint256 constant IC18x = 11530377929168357793860229551575303778285718440879669498978288396067205511206;
    uint256 constant IC18y = 13677515861862471453467469356768542476782128299263432419157652309379295876793;
    
    uint256 constant IC19x = 19239176374162697938603776986566405621583654452586757045334242037051467186459;
    uint256 constant IC19y = 14289126246636743492744548224102409830153150647715649745672497204395568503006;
    
    uint256 constant IC20x = 3047645410384543184002207810302767292366201657461168041360729107986571348194;
    uint256 constant IC20y = 15606027129147838286671121281375198304857159097101208484393223805987767475629;
    
    uint256 constant IC21x = 19001666070244675131182149717660758771911506009044842806431851761297005564163;
    uint256 constant IC21y = 1572183170358835701077092713225169690415925728740041891634508841080526184483;
    
    uint256 constant IC22x = 15679188871741801826918738132995191612548441630840183516424909146166531357975;
    uint256 constant IC22y = 8927022193034830006631268661840099662064746974535016206456508633626694484918;
    
    uint256 constant IC23x = 3289888365411041607247339830722588193700656649459626873520558746584840791363;
    uint256 constant IC23y = 18134799818308841083487018064659189765581816475712582140210158579572232538211;
    
    uint256 constant IC24x = 5693941202804735155822441798414138703539538710747310515091074733596186797142;
    uint256 constant IC24y = 10616129380432136716236661488866720335697725681311638531233230606248650889926;
    
    uint256 constant IC25x = 18520311110609205567661097549914869022438534593971512551216743998802857999873;
    uint256 constant IC25y = 7892536563705357175992817919898563410199557207569717382573049788093811631281;
    
    uint256 constant IC26x = 16557157866231199713130487561224034682556072652642218498250954032067671365152;
    uint256 constant IC26y = 14126144706322927541794287579079694162808561806807891600630221705351720980167;
    
    uint256 constant IC27x = 664701336606487993952354972269210524771012821161764490209120559752807131960;
    uint256 constant IC27y = 17425152749702950126009802451269245854303251180822692134010241329492695012587;
    
    uint256 constant IC28x = 2670000783086995836452356093301738784022488043542480752169358351109420577125;
    uint256 constant IC28y = 3505986810928455653942163039165923009169687395077084317682847460777309137895;
    
    uint256 constant IC29x = 3155329030829214477694541276602313014450194489150124882232285671437838645492;
    uint256 constant IC29y = 16972711727679437909774528886889009609928886792510490657807254799613710704699;
    
    uint256 constant IC30x = 3580885914842265161537481808342534774583638368025186061931139653678697245885;
    uint256 constant IC30y = 18682164264366648141557015820011682344556682084442989430006851605344643122540;
    
    uint256 constant IC31x = 19076755137596286235183940175724216914056625375801249963005691620621813931698;
    uint256 constant IC31y = 4247801097496785714085228726326118916526160649308944842403146372785543829396;
    
    uint256 constant IC32x = 16814619574644130419137954003916901045248955478916523951862237826572322283655;
    uint256 constant IC32y = 7394924261489812349734508838651261001514846079524332119107715273972678007;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[32] calldata _pubSignals) public view returns (bool) {
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
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
